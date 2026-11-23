;;; Helpers shared by the examples: foreign memory, struct construction and
;;; Vulkan result checking.  Load after vulkan.ss / constants.ss:
;;;
;;;   (load "vulkan.ss") (load "constants.ss") (load "examples/common.ss")
;;;   (import (vulkan) (vulkan constants) (examples common))

(library (examples common)
  (export malloc free-all with-scratch new new-array addr
          c-string c-string->string c-string-array
          check create enumerate-array bytes->foreign read-file-bytes
          result->string)
  (import (chezscheme) (vulkan))

  ;; Every allocation is recorded in the current arena.  `free-all` releases
  ;; the long-lived arena; `with-scratch` frees what its body allocated.
  (define arena '())

  (define (malloc size)
    (let ((addr (foreign-alloc (max size 1))))
      (do ((i 0 (+ i 1))) ((= i size))
        (foreign-set! 'unsigned-8 addr i 0))
      (set! arena (cons addr arena))
      addr))

  (define (free-all)
    (for-each foreign-free arena)
    (set! arena '()))

  (define (call-with-scratch thunk)
    (let ((saved arena))
      (set! arena '())
      (call-with-values thunk
        (lambda results
          (for-each foreign-free arena)
          (set! arena saved)
          (apply values results)))))

  (define-syntax with-scratch
    (syntax-rules ()
      ((_ body ...) (call-with-scratch (lambda () body ...)))))

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

  (define (bytes->foreign bv)
    (let* ((n (bytevector-length bv)) (a (malloc n)))
      (do ((i 0 (+ i 1))) ((= i n))
        (foreign-set! 'unsigned-8 a i (bytevector-u8-ref bv i)))
      a))

  (define (c-string s)
    (bytes->foreign (bytevector-append (string->utf8 s) #vu8(0))))

  (define (bytevector-append a b)
    (let ((r (make-bytevector (+ (bytevector-length a) (bytevector-length b)))))
      (bytevector-copy! a 0 r 0 (bytevector-length a))
      (bytevector-copy! b 0 r (bytevector-length a) (bytevector-length b))
      r))

  ;; List of strings => address of a char*[] (for ppEnabledExtensionNames).
  (define (c-string-array strings)
    (let ((p (new-array uptr (length strings))))
      (let loop ((i 0) (ss strings))
        (unless (null? ss)
          (ftype-set! uptr () p i (c-string (car ss)))
          (loop (+ i 1) (cdr ss))))
      (addr p)))

  (define (c-string->string a)
    (let loop ((i 0) (acc '()))
      (let ((b (foreign-ref 'unsigned-8 a i)))
        (if (zero? b)
            (utf8->string (u8-list->bytevector (reverse acc)))
            (loop (+ i 1) (cons b acc))))))

  (define (read-file-bytes path)
    (call-with-port (open-file-input-port path) get-bytevector-all))

  (define (result->string r)
    (cond ((assv r `((,vk:success . "VK_SUCCESS")
                     (,vk:not-ready . "VK_NOT_READY")
                     (,vk:timeout . "VK_TIMEOUT")
                     (,vk:incomplete . "VK_INCOMPLETE")
                     (,vk:suboptimal-khr . "VK_SUBOPTIMAL_KHR")
                     (,vk:error-out-of-host-memory . "VK_ERROR_OUT_OF_HOST_MEMORY")
                     (,vk:error-out-of-device-memory . "VK_ERROR_OUT_OF_DEVICE_MEMORY")
                     (,vk:error-initialization-failed . "VK_ERROR_INITIALIZATION_FAILED")
                     (,vk:error-device-lost . "VK_ERROR_DEVICE_LOST")
                     (,vk:error-layer-not-present . "VK_ERROR_LAYER_NOT_PRESENT")
                     (,vk:error-extension-not-present . "VK_ERROR_EXTENSION_NOT_PRESENT")
                     (,vk:error-feature-not-present . "VK_ERROR_FEATURE_NOT_PRESENT")
                     (,vk:error-incompatible-driver . "VK_ERROR_INCOMPATIBLE_DRIVER")
                     (,vk:error-surface-lost-khr . "VK_ERROR_SURFACE_LOST_KHR")
                     (,vk:error-out-of-date-khr . "VK_ERROR_OUT_OF_DATE_KHR")))
           => cdr)
          (else (number->string r))))

  ;; Signal an error unless a VkResult is VK_SUCCESS.
  (define (check who result)
    (unless (= result vk:success)
      (error who "Vulkan call failed" (result->string result))))

  ;; Call f with a pointer to a fresh handle slot, check the result, and
  ;; return the handle written there.
  (define (create who f)
    (let ((slot (new-array uptr 1)))
      (check who (f (addr slot)))
      (ftype-ref uptr () slot)))

  ;; Vulkan's two-call enumeration pattern.  f receives (count-ptr array-ptr)
  ;; and may return a VkResult (checked) or nothing.  If the count grew
  ;; between the calls (VK_INCOMPLETE), it starts over.
  ;; Returns (values n pointer-to-Ts).
  (define-syntax enumerate-array
    (syntax-rules ()
      ((_ T f)
       (let ((count (new-array unsigned-32 1)) (g f))
         (let retry ()
           (let ((r (g (addr count) 0)))
             (when (number? r) (check 'enumerate-array r)))
           (let* ((n (ftype-ref unsigned-32 () count))
                  (items (new-array T n))
                  (r (g (addr count) (addr items))))
             (cond ((and (number? r) (= r vk:incomplete)) (retry))
                   (else
                    (when (number? r) (check 'enumerate-array r))
                    (values (ftype-ref unsigned-32 () count) items)))))))))
  )
