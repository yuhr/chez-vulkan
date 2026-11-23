;;; Headless Vulkan compute example: squares a buffer of floats on the GPU.
;;;
;;; Run from the repository root:
;;;
;;;   scheme --script examples/compute/compute.ss [device-index]
;;;
;;; The shader is examples/compute/square.comp, compiled to square.spv with
;;;
;;;   glslangValidator -V examples/compute/square.comp -o examples/compute/square.spv

(load "vulkan.ss")
(load "constants.ss")
(import (vulkan) (vulkan constants))

(define element-count 1000)
(define workgroup-size 64)              ; local_size_x in square.comp
(define shader-path "examples/compute/square.spv")

;;; ------------------------------------------------------------------
;;; Small helpers for foreign memory.  Everything allocated through
;;; `malloc` is released by `free-all` at the end.

(define allocations '())

(define (malloc size)
  (let ((addr (foreign-alloc (max size 1))))
    (do ((i 0 (+ i 1))) ((= i size))
      (foreign-set! 'unsigned-8 addr i 0))
    (set! allocations (cons addr allocations))
    addr))

(define (free-all)
  (for-each foreign-free allocations)
  (set! allocations '()))

;; (new T (field ... value) ...) => zeroed ftype pointer with fields set.
;; A field path may be nested: (new T (stage module m)) sets p->stage.module.
(define-syntax new
  (syntax-rules ()
    ((_ T (field ... value) ...)
     (let ((p (make-ftype-pointer T (malloc (ftype-sizeof T)))))
       (ftype-set! T (field ...) p value) ...
       p))))

;; (new-array T n) => zeroed ftype pointer to n consecutive Ts.
(define-syntax new-array
  (syntax-rules ()
    ((_ T n) (make-ftype-pointer T (malloc (* n (ftype-sizeof T)))))))

(define (addr p) (ftype-pointer-address p))

(define (c-string s)
  (let* ((bv (string->utf8 s))
         (n (bytevector-length bv))
         (a (malloc (+ n 1))))
    (do ((i 0 (+ i 1))) ((= i n))
      (foreign-set! 'unsigned-8 a i (bytevector-u8-ref bv i)))
    a))

(define (c-string->string a)
  (let loop ((i 0) (acc '()))
    (let ((b (foreign-ref 'unsigned-8 a i)))
      (if (zero? b)
          (utf8->string (u8-list->bytevector (reverse acc)))
          (loop (+ i 1) (cons b acc))))))

;; Signal an error unless a VkResult is VK_SUCCESS.
(define (check who result)
  (unless (= result vk:success)
    (error who "Vulkan call failed" result)))

;; Call f with a pointer to a fresh handle slot, check the result, and
;; return the handle written there.
(define (create who f)
  (let ((slot (new-array uptr 1)))
    (check who (f (addr slot)))
    (ftype-ref uptr () slot)))

(define (read-file-bytes path)
  (call-with-port (open-file-input-port path) get-bytevector-all))

;;; ------------------------------------------------------------------
;;; Instance and device.

(define instance
  (let* ((app (new vk:application-info
                   (s-type vk:structure-type-application-info)
                   (p-application-name (c-string "chez-vulkan compute"))
                   (application-version 1)
                   (api-version vk:api-version-1-0)))
         (info (new vk:instance-create-info
                    (s-type vk:structure-type-instance-create-info)
                    (p-application-info (addr app)))))
    (create 'vkCreateInstance
            (lambda (out) (vk:create-instance (addr info) 0 out)))))

(define physical-devices
  (let ((count (new-array unsigned-32 1)))
    (check 'vkEnumeratePhysicalDevices
           (vk:enumerate-physical-devices instance (addr count) 0))
    (let* ((n (ftype-ref unsigned-32 () count))
           (devices (new-array uptr n)))
      (check 'vkEnumeratePhysicalDevices
             (vk:enumerate-physical-devices instance (addr count) (addr devices)))
      (let loop ((i (- n 1)) (acc '()))
        (if (< i 0) acc (loop (- i 1) (cons (ftype-ref uptr () devices i) acc)))))))

(define (device-name pd)
  (let ((props (new-array vk:physical-device-properties 1)))
    (vk:get-physical-device-properties pd (addr props))
    (c-string->string (addr (ftype-&ref vk:physical-device-properties (device-name) props)))))

;; Index of the first queue family that supports compute, or #f.
(define (compute-queue-family pd)
  (let ((count (new-array unsigned-32 1)))
    (vk:get-physical-device-queue-family-properties pd (addr count) 0)
    (let* ((n (ftype-ref unsigned-32 () count))
           (props (new-array vk:queue-family-properties n)))
      (vk:get-physical-device-queue-family-properties pd (addr count) (addr props))
      (let loop ((i 0))
        (cond ((= i n) #f)
              ((not (zero? (bitwise-and (ftype-ref vk:queue-family-properties (queue-flags) props i)
                                        vk:queue-compute-bit)))
               i)
              (else (loop (+ i 1))))))))

(define-values (physical-device queue-family)
  (let* ((args (command-line-arguments))
         (candidates (if (null? args)
                         physical-devices
                         (list (list-ref physical-devices (string->number (car args)))))))
    (let loop ((ds candidates))
      (cond ((null? ds) (error 'compute "no device with a compute queue"))
            ((compute-queue-family (car ds)) => (lambda (q) (values (car ds) q)))
            (else (loop (cdr ds)))))))

(printf "device: ~a (queue family ~a)\n" (device-name physical-device) queue-family)

(define device
  (let* ((priority (new-array float 1))
         (_ (ftype-set! float () priority 1.0))
         (queue-info (new vk:device-queue-create-info
                          (s-type vk:structure-type-device-queue-create-info)
                          (queue-family-index queue-family)
                          (queue-count 1)
                          (p-queue-priorities (addr priority))))
         (info (new vk:device-create-info
                    (s-type vk:structure-type-device-create-info)
                    (queue-create-info-count 1)
                    (p-queue-create-infos (addr queue-info)))))
    (create 'vkCreateDevice
            (lambda (out) (vk:create-device physical-device (addr info) 0 out)))))

(define queue
  (let ((slot (new-array uptr 1)))
    (vk:get-device-queue device queue-family 0 (addr slot))
    (ftype-ref uptr () slot)))

;;; ------------------------------------------------------------------
;;; Storage buffer in host-visible, host-coherent memory.

(define buffer-size (* 4 element-count))

(define buffer
  (let ((info (new vk:buffer-create-info
                   (s-type vk:structure-type-buffer-create-info)
                   (size buffer-size)
                   (usage vk:buffer-usage-storage-buffer-bit)
                   (sharing-mode vk:sharing-mode-exclusive))))
    (create 'vkCreateBuffer (lambda (out) (vk:create-buffer device (addr info) 0 out)))))

(define (find-memory-type type-bits wanted)
  (let ((props (new-array vk:physical-device-memory-properties 1)))
    (vk:get-physical-device-memory-properties physical-device (addr props))
    (let loop ((i 0))
      (cond ((= i (ftype-ref vk:physical-device-memory-properties (memory-type-count) props))
             (error 'find-memory-type "no suitable memory type"))
            ((and (bitwise-bit-set? type-bits i)
                  (= wanted (bitwise-and wanted
                                         (ftype-ref vk:physical-device-memory-properties
                                                    (memory-types i property-flags) props))))
             i)
            (else (loop (+ i 1)))))))

(define memory
  (let ((reqs (new-array vk:memory-requirements 1)))
    (vk:get-buffer-memory-requirements device buffer (addr reqs))
    (let ((info (new vk:memory-allocate-info
                     (s-type vk:structure-type-memory-allocate-info)
                     (allocation-size (ftype-ref vk:memory-requirements (size) reqs))
                     (memory-type-index
                      (find-memory-type (ftype-ref vk:memory-requirements (memory-type-bits) reqs)
                                        (bitwise-ior vk:memory-property-host-visible-bit
                                                     vk:memory-property-host-coherent-bit))))))
      (create 'vkAllocateMemory (lambda (out) (vk:allocate-memory device (addr info) 0 out))))))

(check 'vkBindBufferMemory (vk:bind-buffer-memory device buffer memory 0))

(define mapped
  (create 'vkMapMemory (lambda (out) (vk:map-memory device memory 0 vk:whole-size 0 out))))

;; Input: 0.0, 1.0, 2.0, ...
(do ((i 0 (+ i 1))) ((= i element-count))
  (foreign-set! 'float mapped (* 4 i) (inexact i)))

;;; ------------------------------------------------------------------
;;; Compute pipeline.

(define shader-module
  (let* ((code (read-file-bytes shader-path))
         (n (bytevector-length code))
         (code-addr (malloc n)))
    (do ((i 0 (+ i 1))) ((= i n))
      (foreign-set! 'unsigned-8 code-addr i (bytevector-u8-ref code i)))
    (let ((info (new vk:shader-module-create-info
                     (s-type vk:structure-type-shader-module-create-info)
                     (code-size n)
                     (p-code code-addr))))
      (create 'vkCreateShaderModule
              (lambda (out) (vk:create-shader-module device (addr info) 0 out))))))

(define set-layout
  (let* ((binding (new vk:descriptor-set-layout-binding
                       (binding 0)
                       (descriptor-type vk:descriptor-type-storage-buffer)
                       (descriptor-count 1)
                       (stage-flags vk:shader-stage-compute-bit)))
         (info (new vk:descriptor-set-layout-create-info
                    (s-type vk:structure-type-descriptor-set-layout-create-info)
                    (binding-count 1)
                    (p-bindings (addr binding)))))
    (create 'vkCreateDescriptorSetLayout
            (lambda (out) (vk:create-descriptor-set-layout device (addr info) 0 out)))))

(define pipeline-layout
  (let* ((layouts (new-array uptr 1))
         (_ (ftype-set! uptr () layouts set-layout))
         (push-range (new vk:push-constant-range
                          (stage-flags vk:shader-stage-compute-bit)
                          (offset 0)
                          (size 4)))
         (info (new vk:pipeline-layout-create-info
                    (s-type vk:structure-type-pipeline-layout-create-info)
                    (set-layout-count 1)
                    (p-set-layouts (addr layouts))
                    (push-constant-range-count 1)
                    (p-push-constant-ranges (addr push-range)))))
    (create 'vkCreatePipelineLayout
            (lambda (out) (vk:create-pipeline-layout device (addr info) 0 out)))))

(define pipeline
  (let ((info (new vk:compute-pipeline-create-info
                   (s-type vk:structure-type-compute-pipeline-create-info)
                   (stage s-type vk:structure-type-pipeline-shader-stage-create-info)
                   (stage stage vk:shader-stage-compute-bit)
                   (stage module shader-module)
                   (stage p-name (c-string "main"))
                   (layout pipeline-layout)
                   (base-pipeline-index -1))))
    (create 'vkCreateComputePipelines
            (lambda (out) (vk:create-compute-pipelines device 0 1 (addr info) 0 out)))))

;;; ------------------------------------------------------------------
;;; Descriptor set pointing at the buffer.

(define descriptor-pool
  (let* ((pool-size (new vk:descriptor-pool-size
                         (type vk:descriptor-type-storage-buffer)
                         (descriptor-count 1)))
         (info (new vk:descriptor-pool-create-info
                    (s-type vk:structure-type-descriptor-pool-create-info)
                    (max-sets 1)
                    (pool-size-count 1)
                    (p-pool-sizes (addr pool-size)))))
    (create 'vkCreateDescriptorPool
            (lambda (out) (vk:create-descriptor-pool device (addr info) 0 out)))))

(define descriptor-set
  (let* ((layouts (new-array uptr 1))
         (_ (ftype-set! uptr () layouts set-layout))
         (info (new vk:descriptor-set-allocate-info
                    (s-type vk:structure-type-descriptor-set-allocate-info)
                    (descriptor-pool descriptor-pool)
                    (descriptor-set-count 1)
                    (p-set-layouts (addr layouts)))))
    (create 'vkAllocateDescriptorSets
            (lambda (out) (vk:allocate-descriptor-sets device (addr info) out)))))

(let* ((buffer-info (new vk:descriptor-buffer-info
                         (buffer buffer)
                         (offset 0)
                         (range vk:whole-size)))
       (write (new vk:write-descriptor-set
                   (s-type vk:structure-type-write-descriptor-set)
                   (dst-set descriptor-set)
                   (dst-binding 0)
                   (descriptor-count 1)
                   (descriptor-type vk:descriptor-type-storage-buffer)
                   (p-buffer-info (addr buffer-info)))))
  (vk:update-descriptor-sets device 1 (addr write) 0 0))

;;; ------------------------------------------------------------------
;;; Record and submit the dispatch.

(define command-pool
  (let ((info (new vk:command-pool-create-info
                   (s-type vk:structure-type-command-pool-create-info)
                   (queue-family-index queue-family))))
    (create 'vkCreateCommandPool
            (lambda (out) (vk:create-command-pool device (addr info) 0 out)))))

(define command-buffer
  (let ((info (new vk:command-buffer-allocate-info
                   (s-type vk:structure-type-command-buffer-allocate-info)
                   (command-pool command-pool)
                   (level vk:command-buffer-level-primary)
                   (command-buffer-count 1))))
    (create 'vkAllocateCommandBuffers
            (lambda (out) (vk:allocate-command-buffers device (addr info) out)))))

(let ((begin-info (new vk:command-buffer-begin-info
                       (s-type vk:structure-type-command-buffer-begin-info)
                       (flags vk:command-buffer-usage-one-time-submit-bit)))
      (sets (new-array uptr 1))
      (count (new-array unsigned-32 1)))
  (ftype-set! uptr () sets descriptor-set)
  (ftype-set! unsigned-32 () count element-count)
  (check 'vkBeginCommandBuffer (vk:begin-command-buffer command-buffer (addr begin-info)))
  (vk:cmd-bind-pipeline command-buffer vk:pipeline-bind-point-compute pipeline)
  (vk:cmd-bind-descriptor-sets command-buffer vk:pipeline-bind-point-compute
                               pipeline-layout 0 1 (addr sets) 0 0)
  (vk:cmd-push-constants command-buffer pipeline-layout vk:shader-stage-compute-bit
                         0 4 (addr count))
  (vk:cmd-dispatch command-buffer
                   (quotient (+ element-count workgroup-size -1) workgroup-size) 1 1)
  (check 'vkEndCommandBuffer (vk:end-command-buffer command-buffer)))

(define fence
  (let ((info (new vk:fence-create-info (s-type vk:structure-type-fence-create-info))))
    (create 'vkCreateFence (lambda (out) (vk:create-fence device (addr info) 0 out)))))

(let* ((buffers (new-array uptr 1))
       (_ (ftype-set! uptr () buffers command-buffer))
       (submit (new vk:submit-info
                    (s-type vk:structure-type-submit-info)
                    (command-buffer-count 1)
                    (p-command-buffers (addr buffers))))
       (fences (new-array uptr 1)))
  (ftype-set! uptr () fences fence)
  (check 'vkQueueSubmit (vk:queue-submit queue 1 (addr submit) fence))
  (check 'vkWaitForFences (vk:wait-for-fences device 1 (addr fences) vk:true -1)))

;;; ------------------------------------------------------------------
;;; Check the results.

(define results
  (let loop ((i (- element-count 1)) (acc '()))
    (if (< i 0) acc (loop (- i 1) (cons (foreign-ref 'float mapped (* 4 i)) acc)))))

(define mismatches
  (let loop ((i 0) (rs results) (bad 0))
    (if (null? rs)
        bad
        (loop (+ i 1) (cdr rs) (if (= (car rs) (inexact (* i i))) bad (+ bad 1))))))

(printf "first values: ~a
" (list-head results 8))
(printf "last value:   ~a (expected ~a)
"
        (list-ref results (- element-count 1))
        (inexact (* (- element-count 1) (- element-count 1))))
(printf "~a/~a elements correct
" (- element-count mismatches) element-count)

;;; ------------------------------------------------------------------
;;; Clean up.

(vk:destroy-fence device fence 0)
(vk:destroy-command-pool device command-pool 0)
(vk:destroy-descriptor-pool device descriptor-pool 0)
(vk:destroy-pipeline device pipeline 0)
(vk:destroy-pipeline-layout device pipeline-layout 0)
(vk:destroy-descriptor-set-layout device set-layout 0)
(vk:destroy-shader-module device shader-module 0)
(vk:unmap-memory device memory)
(vk:free-memory device memory 0)
(vk:destroy-buffer device buffer 0)
(vk:destroy-device device 0)
(vk:destroy-instance instance 0)
(free-all)

(exit (if (zero? mismatches) 0 1))
