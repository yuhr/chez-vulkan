;;; chezcube: a spinning, textured, lit cube in a GLFW window.
;;;
;;; The texture is a PNG read with Akku's image-formats package, so this
;;; example runs inside the Akku environment.  From the repository root:
;;;
;;;   akku install          # once: fetches image-formats, links the libraries
;;;   .akku/env scheme --script examples/cube/cube.ss [--device N] [--novsync] [--frames N]
;;;
;;; --step DEGREES turns the cube by exactly that much per frame instead of
;;; by elapsed time, for reproducible captures (e.g. --step 4: 90 frames per
;;; revolution).
;;;
;;; Keys: arrows rotate the cube, space pauses the spin, Esc quits.
;;; Shaders: glslangValidator -V examples/cube/cube.vert -o examples/cube/cube.vert.spv
;;;          glslangValidator -V examples/cube/cube.frag -o examples/cube/cube.frag.spv
;;;
;;; image-formats 0.1.0 decodes PNG rows that use the Paeth filter
;;; incorrectly, and reads only 8-bit gray/RGB/RGBA images.  lambda.png is
;;; saved with unfiltered rows; to use another image, re-save it with
;;;   convert in.png -strip -define png:compression-filter=1 PNG24:out.png

(import (chezscheme) (vulkan) (vulkan constants) (image png)
        (examples common) (examples glfw) (examples math))

;;; ------------------------------------------------------------------
;;; Options.

(define (option name default convert)
  (let loop ((args (command-line-arguments)))
    (cond ((null? args) default)
          ((string=? (car args) name)
           (if convert
               (if (pair? (cdr args)) (convert (cadr args)) (error 'cube "missing value" name))
               #t))
          (else (loop (cdr args))))))

(define device-choice (option "--device" #f string->number))
(define no-vsync? (option "--novsync" #f #f))
(define frame-limit (option "--frames" #f string->number))
(define spin-step (option "--step" #f string->number))
(define texture-path "examples/cube/lambda.png")
(define frames-in-flight 2)

;;; ------------------------------------------------------------------
;;; Cube geometry: 6 faces x 2 triangles, each vertex (x y z nx ny nz u v).
;;; Every face is wound counter-clockwise when seen from outside.

(define (cross a b)
  (list (- (* (cadr a) (caddr b)) (* (caddr a) (cadr b)))
        (- (* (caddr a) (car b)) (* (car a) (caddr b)))
        (- (* (car a) (cadr b)) (* (cadr a) (car b)))))

(define (v+ . vs) (apply map + vs))
(define (v- a b) (map - a b))

(define cube-vertices
  (apply append
         (map (lambda (face)
                (let* ((n (car face)) (up (cadr face))
                       (right (cross up n))   ; right x up = n
                       (corner (lambda (du dv uv)
                                 (append ((if (> du 0) v+ v-) ((if (> dv 0) v+ v-) n up) right)
                                         n uv)))
                       (bl (corner -1 -1 '(0.0 1.0)))
                       (br (corner 1 -1 '(1.0 1.0)))
                       (tr (corner 1 1 '(1.0 0.0)))
                       (tl (corner -1 1 '(0.0 0.0))))
                  (list bl br tr bl tr tl)))
              '(((1 0 0) (0 1 0)) ((-1 0 0) (0 1 0))
                ((0 0 1) (0 1 0)) ((0 0 -1) (0 1 0))
                ((0 1 0) (0 0 -1)) ((0 -1 0) (0 0 1))))))

;;; ------------------------------------------------------------------
;;; Window, instance, surface.

(glfw-init)
(define window (glfw-create-window 640 480 "chezcube"))

(define instance
  (let* ((app (new vk:application-info
                   (s-type vk:structure-type-application-info)
                   (p-application-name (c-string "chezcube"))
                   (application-version 1)
                   (api-version vk:api-version-1-3)))
         (extensions (glfw-required-instance-extensions))
         (info (new vk:instance-create-info
                    (s-type vk:structure-type-instance-create-info)
                    (p-application-info (addr app))
                    (enabled-extension-count (length extensions))
                    (pp-enabled-extension-names (c-string-array extensions)))))
    (create 'vkCreateInstance (lambda (out) (vk:create-instance (addr info) 0 out)))))

(define surface (glfw-create-window-surface instance window))

;;; ------------------------------------------------------------------
;;; Physical device: Vulkan 1.3, VK_KHR_swapchain, graphics + present queue.

(define (device-properties pd)
  (let ((props (new-array vk:physical-device-properties 1)))
    (vk:get-physical-device-properties pd (addr props))
    (values (c-string->string (addr (ftype-&ref vk:physical-device-properties (device-name) props)))
            (ftype-ref vk:physical-device-properties (api-version) props)
            (ftype-ref vk:physical-device-properties (limits max-sampler-anisotropy) props))))

(define (has-device-extension? pd name)
  (with-scratch
   (let-values (((n exts) (enumerate-array vk:extension-properties
                                           (lambda (c p) (vk:enumerate-device-extension-properties pd 0 c p)))))
     (let loop ((i 0))
       (and (< i n)
            (or (string=? name (c-string->string
                                (addr (ftype-&ref vk:extension-properties (extension-name) exts i))))
                (loop (+ i 1))))))))

(define (graphics-present-family pd)
  (with-scratch
   (let-values (((n families) (enumerate-array vk:queue-family-properties
                                               (lambda (c p) (vk:get-physical-device-queue-family-properties pd c p))))
                ((supported) (new-array unsigned-32 1)))
     (let loop ((i 0))
       (cond ((= i n) #f)
             ((and (not (zero? (bitwise-and (ftype-ref vk:queue-family-properties (queue-flags) families i)
                                            vk:queue-graphics-bit)))
                   (begin (vk:get-physical-device-surface-support-khr pd i surface (addr supported))
                          (= 1 (ftype-ref unsigned-32 () supported))))
              i)
             (else (loop (+ i 1))))))))

(define (usable-device pd)
  (let-values (((name api max-aniso) (device-properties pd)))
    (and (>= api vk:api-version-1-3)
         (has-device-extension? pd "VK_KHR_swapchain")
         (graphics-present-family pd))))

(define-values (physical-device queue-family)
  (let-values (((n devices) (enumerate-array uptr (lambda (c p) (vk:enumerate-physical-devices instance c p)))))
    (when (and device-choice (not (and (fixnum? device-choice) (< -1 device-choice n))))
      (error 'cube "no such device; --device takes 0 to" (- n 1)))
    (let ((candidates (if device-choice
                          (list (ftype-ref uptr () devices device-choice))
                          (let loop ((i (- n 1)) (acc '()))
                            (if (< i 0) acc (loop (- i 1) (cons (ftype-ref uptr () devices i) acc)))))))
      (let loop ((ds candidates))
        (cond ((null? ds) (error 'cube "no device with Vulkan 1.3, VK_KHR_swapchain and presentation"))
              ((usable-device (car ds)) => (lambda (q) (values (car ds) q)))
              (else (loop (cdr ds))))))))

;; Anisotropic filtering, if the device has it.
(define max-anisotropy
  (with-scratch
   (let ((features (new-array vk:physical-device-features 1)))
     (vk:get-physical-device-features physical-device (addr features))
     (and (= vk:true (ftype-ref vk:physical-device-features (sampler-anisotropy) features))
          (let-values (((name api max-aniso) (device-properties physical-device)))
            (min 16.0 max-aniso))))))

(let-values (((name api max-aniso) (device-properties physical-device)))
  (printf "device: ~a (Vulkan ~a.~a)\n" name (vk:api-version-major api) (vk:api-version-minor api)))

(define device
  (let* ((priority (new-array float 1))
         (_ (ftype-set! float () priority 1.0))
         (queue-info (new vk:device-queue-create-info
                          (s-type vk:structure-type-device-queue-create-info)
                          (queue-family-index queue-family)
                          (queue-count 1)
                          (p-queue-priorities (addr priority))))
         (features13 (new vk:physical-device-vulkan13-features
                          (s-type vk:structure-type-physical-device-vulkan-1-3-features)
                          (synchronization2 vk:true)
                          (dynamic-rendering vk:true)))
         (features (new vk:physical-device-features2
                        (s-type vk:structure-type-physical-device-features-2)
                        (p-next (addr features13))
                        (features sampler-anisotropy (if max-anisotropy vk:true vk:false))))
         (extensions '("VK_KHR_swapchain"))
         (info (new vk:device-create-info
                    (s-type vk:structure-type-device-create-info)
                    (p-next (addr features))
                    (queue-create-info-count 1)
                    (p-queue-create-infos (addr queue-info))
                    (enabled-extension-count (length extensions))
                    (pp-enabled-extension-names (c-string-array extensions)))))
    (create 'vkCreateDevice (lambda (out) (vk:create-device physical-device (addr info) 0 out)))))

(define queue
  (let ((slot (new-array uptr 1)))
    (vk:get-device-queue device queue-family 0 (addr slot))
    (ftype-ref uptr () slot)))

;;; ------------------------------------------------------------------
;;; Memory, buffers, one-off commands.

(define (find-memory-type type-bits wanted)
  (with-scratch
   (let ((props (new-array vk:physical-device-memory-properties 1)))
     (vk:get-physical-device-memory-properties physical-device (addr props))
     (let loop ((i 0))
       (cond ((= i (ftype-ref vk:physical-device-memory-properties (memory-type-count) props))
              (error 'find-memory-type "no suitable memory type"))
             ((and (bitwise-bit-set? type-bits i)
                   (= wanted (bitwise-and wanted (ftype-ref vk:physical-device-memory-properties
                                                            (memory-types i property-flags) props))))
              i)
             (else (loop (+ i 1))))))))

(define (allocate-memory reqs properties)
  (with-scratch
   (let ((info (new vk:memory-allocate-info
                    (s-type vk:structure-type-memory-allocate-info)
                    (allocation-size (ftype-ref vk:memory-requirements (size) reqs))
                    (memory-type-index (find-memory-type (ftype-ref vk:memory-requirements (memory-type-bits) reqs)
                                                         properties)))))
     (create 'vkAllocateMemory (lambda (out) (vk:allocate-memory device (addr info) 0 out))))))

;; Host-visible buffer filled from a bytevector => (values buffer memory).
(define (make-host-buffer bytes usage)
  (with-scratch
   (let* ((size (bytevector-length bytes))
          (info (new vk:buffer-create-info
                     (s-type vk:structure-type-buffer-create-info)
                     (size size)
                     (usage usage)
                     (sharing-mode vk:sharing-mode-exclusive)))
          (buffer (create 'vkCreateBuffer (lambda (out) (vk:create-buffer device (addr info) 0 out))))
          (reqs (new-array vk:memory-requirements 1)))
     (vk:get-buffer-memory-requirements device buffer (addr reqs))
     (let ((memory (allocate-memory reqs (bitwise-ior vk:memory-property-host-visible-bit
                                                      vk:memory-property-host-coherent-bit))))
       (check 'vkBindBufferMemory (vk:bind-buffer-memory device buffer memory 0))
       (let ((mapped (create 'vkMapMemory (lambda (out) (vk:map-memory device memory 0 vk:whole-size 0 out)))))
         (do ((i 0 (+ i 1))) ((= i size))
           (foreign-set! 'unsigned-8 mapped i (bytevector-u8-ref bytes i)))
         (vk:unmap-memory device memory))
       (values buffer memory)))))

(define command-pool
  (with-scratch
   (let ((info (new vk:command-pool-create-info
                    (s-type vk:structure-type-command-pool-create-info)
                    (flags vk:command-pool-create-reset-command-buffer-bit)
                    (queue-family-index queue-family))))
     (create 'vkCreateCommandPool (lambda (out) (vk:create-command-pool device (addr info) 0 out))))))

;; Record commands with (record cmd), submit them and wait.
(define (run-commands! record)
  (with-scratch
   (let* ((alloc-info (new vk:command-buffer-allocate-info
                           (s-type vk:structure-type-command-buffer-allocate-info)
                           (command-pool command-pool)
                           (level vk:command-buffer-level-primary)
                           (command-buffer-count 1)))
          (slot (new-array uptr 1)))
     (check 'vkAllocateCommandBuffers (vk:allocate-command-buffers device (addr alloc-info) (addr slot)))
     (let ((cmd (ftype-ref uptr () slot))
           (begin-info (new vk:command-buffer-begin-info
                            (s-type vk:structure-type-command-buffer-begin-info)
                            (flags vk:command-buffer-usage-one-time-submit-bit))))
       (check 'vkBeginCommandBuffer (vk:begin-command-buffer cmd (addr begin-info)))
       (record cmd)
       (check 'vkEndCommandBuffer (vk:end-command-buffer cmd))
       (let ((submit (new vk:submit-info
                          (s-type vk:structure-type-submit-info)
                          (command-buffer-count 1)
                          (p-command-buffers (addr slot)))))
         (check 'vkQueueSubmit (vk:queue-submit queue 1 (addr submit) 0))
         (check 'vkQueueWaitIdle (vk:queue-wait-idle queue))
         (vk:free-command-buffers device command-pool 1 (addr slot)))))))

;; A single image layout transition (setup-time only).
(define (image-barrier! cmd image aspect base-level levels from-layout to-layout
                        src-stage src-access dst-stage dst-access)
  (with-scratch
   (let* ((barrier (new vk:image-memory-barrier2
                        (s-type vk:structure-type-image-memory-barrier-2)
                        (src-stage-mask src-stage) (src-access-mask src-access)
                        (dst-stage-mask dst-stage) (dst-access-mask dst-access)
                        (old-layout from-layout) (new-layout to-layout)
                        (src-queue-family-index vk:queue-family-ignored)
                        (dst-queue-family-index vk:queue-family-ignored)
                        (image image)
                        (subresource-range aspect-mask aspect)
                        (subresource-range base-mip-level base-level)
                        (subresource-range level-count levels)
                        (subresource-range layer-count 1)))
          (dependency (new vk:dependency-info
                           (s-type vk:structure-type-dependency-info)
                           (image-memory-barrier-count 1)
                           (p-image-memory-barriers (addr barrier)))))
     (vk:cmd-pipeline-barrier2 cmd (addr dependency)))))

(define (create-view image format aspect levels)
  (with-scratch
   (let ((info (new vk:image-view-create-info
                    (s-type vk:structure-type-image-view-create-info)
                    (image image)
                    (view-type vk:image-view-type-2d)
                    (format format)
                    (subresource-range aspect-mask aspect)
                    (subresource-range level-count levels)
                    (subresource-range layer-count 1))))
     (create 'vkCreateImageView (lambda (out) (vk:create-image-view device (addr info) 0 out))))))

;;; ------------------------------------------------------------------
;;; Texture: PNG -> RGBA8 -> staging buffer -> sRGB image with mipmaps.

(define (png->rgba img)
  (let* ((w (png-width img)) (h (png-height img)) (data (png-data img))
         (channels (case (png-color-type img)
                     ((gray) 1) ((gray-alpha) 2) ((rgb) 3) ((rgba) 4)
                     (else (error 'png->rgba "unsupported PNG color type" (png-color-type img)))))
         (rgba (make-bytevector (* w h 4) 255)))
    (unless (= 8 (png-color-bits img))
      (error 'png->rgba "only 8-bit PNGs are supported" (png-color-bits img)))
    (do ((i 0 (+ i 1))) ((= i (* w h)) rgba)
      (let ((src (* i channels)) (dst (* i 4)))
        (case channels
          ((1 2) (let ((g (bytevector-u8-ref data src)))
                   (bytevector-u8-set! rgba dst g)
                   (bytevector-u8-set! rgba (+ dst 1) g)
                   (bytevector-u8-set! rgba (+ dst 2) g)
                   (when (= channels 2)
                     (bytevector-u8-set! rgba (+ dst 3) (bytevector-u8-ref data (+ src 1))))))
          (else (do ((c 0 (+ c 1))) ((= c channels))
                  (bytevector-u8-set! rgba (+ dst c) (bytevector-u8-ref data (+ src c))))))))))

(define texture-format vk:format-r8g8b8a8-srgb)

(define-values (texture-image texture-memory texture-levels texture-width texture-height)
  (let* ((img (call-with-port (open-file-input-port texture-path) read-png))
         (w (png-width img)) (h (png-height img))
         (can-blit? (with-scratch
                     (let ((props (new-array vk:format-properties 1))
                           (needed (bitwise-ior vk:format-feature-blit-src-bit
                                                vk:format-feature-blit-dst-bit
                                                vk:format-feature-sampled-image-filter-linear-bit)))
                       (vk:get-physical-device-format-properties physical-device texture-format (addr props))
                       (= needed (bitwise-and needed (ftype-ref vk:format-properties (optimal-tiling-features) props))))))
         ;; floor(log2(max(w, h))) + 1 levels, down to 1x1
         (levels (if can-blit? (bitwise-length (max w h)) 1)))
    (let-values (((staging staging-memory) (make-host-buffer (png->rgba img) vk:buffer-usage-transfer-src-bit)))
      (let* ((image (with-scratch
                     (let ((info (new vk:image-create-info
                                      (s-type vk:structure-type-image-create-info)
                                      (image-type vk:image-type-2d)
                                      (format texture-format)
                                      (extent width w) (extent height h) (extent depth 1)
                                      (mip-levels levels)
                                      (array-layers 1)
                                      (samples vk:sample-count-1-bit)
                                      (tiling vk:image-tiling-optimal)
                                      (usage (bitwise-ior vk:image-usage-transfer-src-bit
                                                          vk:image-usage-transfer-dst-bit
                                                          vk:image-usage-sampled-bit))
                                      (sharing-mode vk:sharing-mode-exclusive)
                                      (initial-layout vk:image-layout-undefined))))
                       (create 'vkCreateImage (lambda (out) (vk:create-image device (addr info) 0 out))))))
             (memory (with-scratch
                      (let ((reqs (new-array vk:memory-requirements 1)))
                        (vk:get-image-memory-requirements device image (addr reqs))
                        (allocate-memory reqs vk:memory-property-device-local-bit))))
             (color vk:image-aspect-color-bit)
             (transfer vk:pipeline-stage-2-all-transfer-bit))
        (check 'vkBindImageMemory (vk:bind-image-memory device image memory 0))
        (run-commands!
         (lambda (cmd)
           (image-barrier! cmd image color 0 levels
                           vk:image-layout-undefined vk:image-layout-transfer-dst-optimal
                           vk:pipeline-stage-2-none vk:access-2-none
                           transfer vk:access-2-transfer-write-bit)
           (with-scratch
            (let ((region (new vk:buffer-image-copy
                               (image-subresource aspect-mask color)
                               (image-subresource layer-count 1)
                               (image-extent width w) (image-extent height h) (image-extent depth 1))))
              (vk:cmd-copy-buffer-to-image cmd staging image vk:image-layout-transfer-dst-optimal
                                           1 (addr region))))
           ;; Each level is a linear downscale of the previous one.
           (do ((level 1 (+ level 1))) ((= level levels))
             (image-barrier! cmd image color (- level 1) 1
                             vk:image-layout-transfer-dst-optimal vk:image-layout-transfer-src-optimal
                             transfer vk:access-2-transfer-write-bit
                             transfer vk:access-2-transfer-read-bit)
             (with-scratch
              (let ((blit (new vk:image-blit
                               (src-subresource aspect-mask color)
                               (src-subresource mip-level (- level 1))
                               (src-subresource layer-count 1)
                               (src-offsets 1 x (max 1 (bitwise-arithmetic-shift-right w (- level 1))))
                               (src-offsets 1 y (max 1 (bitwise-arithmetic-shift-right h (- level 1))))
                               (src-offsets 1 z 1)
                               (dst-subresource aspect-mask color)
                               (dst-subresource mip-level level)
                               (dst-subresource layer-count 1)
                               (dst-offsets 1 x (max 1 (bitwise-arithmetic-shift-right w level)))
                               (dst-offsets 1 y (max 1 (bitwise-arithmetic-shift-right h level)))
                               (dst-offsets 1 z 1))))
                (vk:cmd-blit-image cmd image vk:image-layout-transfer-src-optimal
                                   image vk:image-layout-transfer-dst-optimal
                                   1 (addr blit) vk:filter-linear))))
           ;; Levels 0..n-2 were blit sources; the last one was only written.
           (when (> levels 1)
             (image-barrier! cmd image color 0 (- levels 1)
                             vk:image-layout-transfer-src-optimal vk:image-layout-shader-read-only-optimal
                             transfer vk:access-2-transfer-read-bit
                             vk:pipeline-stage-2-fragment-shader-bit vk:access-2-shader-sampled-read-bit))
           (image-barrier! cmd image color (- levels 1) 1
                           vk:image-layout-transfer-dst-optimal vk:image-layout-shader-read-only-optimal
                           transfer vk:access-2-transfer-write-bit
                           vk:pipeline-stage-2-fragment-shader-bit vk:access-2-shader-sampled-read-bit)))
        (vk:destroy-buffer device staging 0)
        (vk:free-memory device staging-memory 0)
        (values image memory levels w h)))))

(printf "texture: ~a (~ax~a, ~a mip levels~a)\n" texture-path texture-width texture-height texture-levels
        (if max-anisotropy (format ", ~ax anisotropic" (exact (round max-anisotropy))) ""))

(define texture-view (create-view texture-image texture-format vk:image-aspect-color-bit texture-levels))

(define sampler
  (with-scratch
   (let ((info (new vk:sampler-create-info
                    (s-type vk:structure-type-sampler-create-info)
                    (mag-filter vk:filter-linear)
                    (min-filter vk:filter-linear)
                    (mipmap-mode vk:sampler-mipmap-mode-linear)
                    (address-mode-u vk:sampler-address-mode-clamp-to-edge)
                    (address-mode-v vk:sampler-address-mode-clamp-to-edge)
                    (address-mode-w vk:sampler-address-mode-clamp-to-edge)
                    (anisotropy-enable (if max-anisotropy vk:true vk:false))
                    (max-anisotropy (or max-anisotropy 1.0))
                    (max-lod vk:lod-clamp-none))))
     (create 'vkCreateSampler (lambda (out) (vk:create-sampler device (addr info) 0 out))))))

;;; ------------------------------------------------------------------
;;; Descriptor set: binding 0 = the texture and its sampler.

(define set-layout
  (with-scratch
   (let* ((binding (new vk:descriptor-set-layout-binding
                        (binding 0)
                        (descriptor-type vk:descriptor-type-combined-image-sampler)
                        (descriptor-count 1)
                        (stage-flags vk:shader-stage-fragment-bit)))
          (info (new vk:descriptor-set-layout-create-info
                     (s-type vk:structure-type-descriptor-set-layout-create-info)
                     (binding-count 1)
                     (p-bindings (addr binding)))))
     (create 'vkCreateDescriptorSetLayout
             (lambda (out) (vk:create-descriptor-set-layout device (addr info) 0 out))))))

(define descriptor-pool
  (with-scratch
   (let* ((size (new vk:descriptor-pool-size
                     (type vk:descriptor-type-combined-image-sampler)
                     (descriptor-count 1)))
          (info (new vk:descriptor-pool-create-info
                     (s-type vk:structure-type-descriptor-pool-create-info)
                     (max-sets 1)
                     (pool-size-count 1)
                     (p-pool-sizes (addr size)))))
     (create 'vkCreateDescriptorPool (lambda (out) (vk:create-descriptor-pool device (addr info) 0 out))))))

(define descriptor-set
  (with-scratch
   (let* ((layouts (new-array uptr 1))
          (_ (ftype-set! uptr () layouts set-layout))
          (info (new vk:descriptor-set-allocate-info
                     (s-type vk:structure-type-descriptor-set-allocate-info)
                     (descriptor-pool descriptor-pool)
                     (descriptor-set-count 1)
                     (p-set-layouts (addr layouts))))
          (set (create 'vkAllocateDescriptorSets (lambda (out) (vk:allocate-descriptor-sets device (addr info) out))))
          (image-info (new vk:descriptor-image-info
                           (sampler sampler)
                           (image-view texture-view)
                           (image-layout vk:image-layout-shader-read-only-optimal)))
          (write (new vk:write-descriptor-set
                      (s-type vk:structure-type-write-descriptor-set)
                      (dst-set set)
                      (dst-binding 0)
                      (descriptor-count 1)
                      (descriptor-type vk:descriptor-type-combined-image-sampler)
                      (p-image-info (addr image-info)))))
     (vk:update-descriptor-sets device 1 (addr write) 0 0)
     set)))

;;; ------------------------------------------------------------------
;;; Vertex buffer.

(define vertex-count (length cube-vertices))
(define-values (vertex-buffer vertex-memory)
  (let ((bv (make-bytevector (* vertex-count 8 4))))
    (let loop ((vs cube-vertices) (i 0))
      (unless (null? vs)
        (let put ((xs (car vs)) (j 0))
          (unless (null? xs)
            (bytevector-ieee-single-native-set! bv (* 4 (+ (* 8 i) j)) (inexact (car xs)))
            (put (cdr xs) (+ j 1))))
        (loop (cdr vs) (+ i 1))))
    (make-host-buffer bv vk:buffer-usage-vertex-buffer-bit)))

;;; ------------------------------------------------------------------
;;; Surface format, depth format, present mode.

(define-values (surface-format color-space)
  (with-scratch
   (let-values (((n formats) (enumerate-array vk:surface-format-khr
                                              (lambda (c p) (vk:get-physical-device-surface-formats-khr
                                                             physical-device surface c p)))))
     ;; sRGB, so the sRGB texture is displayed with the right colors.
     (let loop ((i 0))
       (cond ((= i n) (values (ftype-ref vk:surface-format-khr (format) formats 0)
                              (ftype-ref vk:surface-format-khr (color-space) formats 0)))
             ((and (memv (ftype-ref vk:surface-format-khr (format) formats i)
                         (list vk:format-b8g8r8a8-srgb vk:format-r8g8b8a8-srgb))
                   (= (ftype-ref vk:surface-format-khr (color-space) formats i)
                      vk:color-space-srgb-nonlinear-khr))
              (values (ftype-ref vk:surface-format-khr (format) formats i)
                      (ftype-ref vk:surface-format-khr (color-space) formats i)))
             (else (loop (+ i 1))))))))

(define depth-format
  (with-scratch
   (let ((props (new-array vk:format-properties 1)))
     (vk:get-physical-device-format-properties physical-device vk:format-d32-sfloat (addr props))
     (if (zero? (bitwise-and (ftype-ref vk:format-properties (optimal-tiling-features) props)
                             vk:format-feature-depth-stencil-attachment-bit))
         vk:format-d16-unorm
         vk:format-d32-sfloat))))

(define present-mode
  (with-scratch
   (let-values (((n modes) (enumerate-array unsigned-32
                                            (lambda (c p) (vk:get-physical-device-surface-present-modes-khr
                                                           physical-device surface c p)))))
     (let ((available (let loop ((i 0) (acc '()))
                        (if (= i n) acc (loop (+ i 1) (cons (ftype-ref unsigned-32 () modes i) acc))))))
       (cond ((not no-vsync?) vk:present-mode-fifo-khr)
             ((memv vk:present-mode-mailbox-khr available) vk:present-mode-mailbox-khr)
             ((memv vk:present-mode-immediate-khr available) vk:present-mode-immediate-khr)
             (else vk:present-mode-fifo-khr))))))

(printf "present mode: ~a\n"
        (cdr (assv present-mode `((,vk:present-mode-fifo-khr . "FIFO (vsync)")
                                  (,vk:present-mode-mailbox-khr . "mailbox")
                                  (,vk:present-mode-immediate-khr . "immediate")))))

;;; ------------------------------------------------------------------
;;; Pipeline.

(define (shader-module path)
  (with-scratch
   (let* ((code (read-file-bytes path))
          (info (new vk:shader-module-create-info
                     (s-type vk:structure-type-shader-module-create-info)
                     (code-size (bytevector-length code))
                     (p-code (bytes->foreign code)))))
     (create 'vkCreateShaderModule (lambda (out) (vk:create-shader-module device (addr info) 0 out))))))

(define push-constant-size 112)          ; mat4 mvp + mat3 normal matrix

(define pipeline-layout
  (with-scratch
   (let* ((layouts (new-array uptr 1))
          (_ (ftype-set! uptr () layouts set-layout))
          (range (new vk:push-constant-range
                      (stage-flags vk:shader-stage-vertex-bit)
                      (offset 0)
                      (size push-constant-size)))
          (info (new vk:pipeline-layout-create-info
                     (s-type vk:structure-type-pipeline-layout-create-info)
                     (set-layout-count 1)
                     (p-set-layouts (addr layouts))
                     (push-constant-range-count 1)
                     (p-push-constant-ranges (addr range)))))
     (create 'vkCreatePipelineLayout (lambda (out) (vk:create-pipeline-layout device (addr info) 0 out))))))

(define pipeline
  (let ((vert (shader-module "examples/cube/cube.vert.spv"))
        (frag (shader-module "examples/cube/cube.frag.spv")))
    (let ((p (with-scratch
              (let* ((main (c-string "main"))
                     (stages (new-array vk:pipeline-shader-stage-create-info 2))
                     (_ (for-each (lambda (i stage module)
                                    (ftype-set! vk:pipeline-shader-stage-create-info (s-type) stages i
                                                vk:structure-type-pipeline-shader-stage-create-info)
                                    (ftype-set! vk:pipeline-shader-stage-create-info (stage) stages i stage)
                                    (ftype-set! vk:pipeline-shader-stage-create-info (module) stages i module)
                                    (ftype-set! vk:pipeline-shader-stage-create-info (p-name) stages i main))
                                  '(0 1)
                                  (list vk:shader-stage-vertex-bit vk:shader-stage-fragment-bit)
                                  (list vert frag)))
                     (binding (new vk:vertex-input-binding-description
                                   (binding 0) (stride 32) (input-rate vk:vertex-input-rate-vertex)))
                     (attributes (new-array vk:vertex-input-attribute-description 3))
                     (_ (for-each (lambda (i format offset)
                                    (ftype-set! vk:vertex-input-attribute-description (location) attributes i i)
                                    (ftype-set! vk:vertex-input-attribute-description (format) attributes i format)
                                    (ftype-set! vk:vertex-input-attribute-description (offset) attributes i offset))
                                  '(0 1 2)
                                  (list vk:format-r32g32b32-sfloat vk:format-r32g32b32-sfloat vk:format-r32g32-sfloat)
                                  '(0 12 24)))
                     (vertex-input (new vk:pipeline-vertex-input-state-create-info
                                        (s-type vk:structure-type-pipeline-vertex-input-state-create-info)
                                        (vertex-binding-description-count 1)
                                        (p-vertex-binding-descriptions (addr binding))
                                        (vertex-attribute-description-count 3)
                                        (p-vertex-attribute-descriptions (addr attributes))))
                     (input-assembly (new vk:pipeline-input-assembly-state-create-info
                                          (s-type vk:structure-type-pipeline-input-assembly-state-create-info)
                                          (topology vk:primitive-topology-triangle-list)))
                     (viewport-state (new vk:pipeline-viewport-state-create-info
                                          (s-type vk:structure-type-pipeline-viewport-state-create-info)
                                          (viewport-count 1)
                                          (scissor-count 1)))
                     (raster (new vk:pipeline-rasterization-state-create-info
                                  (s-type vk:structure-type-pipeline-rasterization-state-create-info)
                                  (polygon-mode vk:polygon-mode-fill)
                                  (cull-mode vk:cull-mode-back-bit)
                                  (front-face vk:front-face-counter-clockwise)
                                  (line-width 1.0)))
                     (multisample (new vk:pipeline-multisample-state-create-info
                                       (s-type vk:structure-type-pipeline-multisample-state-create-info)
                                       (rasterization-samples vk:sample-count-1-bit)))
                     (depth (new vk:pipeline-depth-stencil-state-create-info
                                 (s-type vk:structure-type-pipeline-depth-stencil-state-create-info)
                                 (depth-test-enable vk:true)
                                 (depth-write-enable vk:true)
                                 (depth-compare-op vk:compare-op-less)))
                     (blend-attachment (new vk:pipeline-color-blend-attachment-state
                                            (color-write-mask (bitwise-ior vk:color-component-r-bit
                                                                           vk:color-component-g-bit
                                                                           vk:color-component-b-bit
                                                                           vk:color-component-a-bit))))
                     (blend (new vk:pipeline-color-blend-state-create-info
                                 (s-type vk:structure-type-pipeline-color-blend-state-create-info)
                                 (attachment-count 1)
                                 (p-attachments (addr blend-attachment))))
                     (dynamic-states (new-array unsigned-32 2))
                     (_ (begin (ftype-set! unsigned-32 () dynamic-states 0 vk:dynamic-state-viewport)
                               (ftype-set! unsigned-32 () dynamic-states 1 vk:dynamic-state-scissor)))
                     (dynamic (new vk:pipeline-dynamic-state-create-info
                                   (s-type vk:structure-type-pipeline-dynamic-state-create-info)
                                   (dynamic-state-count 2)
                                   (p-dynamic-states (addr dynamic-states))))
                     (color-format (new-array unsigned-32 1))
                     (_ (ftype-set! unsigned-32 () color-format surface-format))
                     (rendering (new vk:pipeline-rendering-create-info
                                     (s-type vk:structure-type-pipeline-rendering-create-info)
                                     (color-attachment-count 1)
                                     (p-color-attachment-formats (addr color-format))
                                     (depth-attachment-format depth-format)))
                     (info (new vk:graphics-pipeline-create-info
                                (s-type vk:structure-type-graphics-pipeline-create-info)
                                (p-next (addr rendering))
                                (stage-count 2)
                                (p-stages (addr stages))
                                (p-vertex-input-state (addr vertex-input))
                                (p-input-assembly-state (addr input-assembly))
                                (p-viewport-state (addr viewport-state))
                                (p-rasterization-state (addr raster))
                                (p-multisample-state (addr multisample))
                                (p-depth-stencil-state (addr depth))
                                (p-color-blend-state (addr blend))
                                (p-dynamic-state (addr dynamic))
                                (layout pipeline-layout)
                                (base-pipeline-index -1))))
                (create 'vkCreateGraphicsPipelines
                        (lambda (out) (vk:create-graphics-pipelines device 0 1 (addr info) 0 out)))))))
      (vk:destroy-shader-module device vert 0)
      (vk:destroy-shader-module device frag 0)
      p)))

;;; ------------------------------------------------------------------
;;; Swapchain, image views, depth buffer, per-image semaphores.

(define swapchain 0)
(define extent-width 0)
(define extent-height 0)
(define swapchain-images '#())
(define swapchain-views '#())
(define render-done '#())
(define depth-image 0)
(define depth-memory 0)
(define depth-view 0)

(define (create-semaphore)
  (with-scratch
   (let ((info (new vk:semaphore-create-info (s-type vk:structure-type-semaphore-create-info))))
     (create 'vkCreateSemaphore (lambda (out) (vk:create-semaphore device (addr info) 0 out))))))

(define (destroy-swapchain-resources)
  (vector-for-each (lambda (v) (vk:destroy-image-view device v 0)) swapchain-views)
  (vector-for-each (lambda (s) (vk:destroy-semaphore device s 0)) render-done)
  (unless (zero? depth-view)
    (vk:destroy-image-view device depth-view 0)
    (vk:destroy-image device depth-image 0)
    (vk:free-memory device depth-memory 0)
    (set! depth-view 0)))

;; Returns #f when the window has no area (minimized), #t otherwise.
(define (create-swapchain!)
  (with-scratch
   (let ((caps (new-array vk:surface-capabilities-khr 1)))
     (check 'vkGetPhysicalDeviceSurfaceCapabilitiesKHR
            (vk:get-physical-device-surface-capabilities-khr physical-device surface (addr caps)))
     (let-values (((fb-w fb-h) (glfw-framebuffer-size window)))
       (let* ((current-w (ftype-ref vk:surface-capabilities-khr (current-extent width) caps))
              (clamp (lambda (v lo hi) (max lo (min hi v))))
              ;; 0xFFFFFFFF: the surface takes its size from the swapchain (Wayland).
              (w (if (= current-w #xFFFFFFFF)
                     (clamp fb-w (ftype-ref vk:surface-capabilities-khr (min-image-extent width) caps)
                            (ftype-ref vk:surface-capabilities-khr (max-image-extent width) caps))
                     current-w))
              (h (if (= current-w #xFFFFFFFF)
                     (clamp fb-h (ftype-ref vk:surface-capabilities-khr (min-image-extent height) caps)
                            (ftype-ref vk:surface-capabilities-khr (max-image-extent height) caps))
                     (ftype-ref vk:surface-capabilities-khr (current-extent height) caps))))
         (and (> w 0) (> h 0)
              (let* ((min-count (ftype-ref vk:surface-capabilities-khr (min-image-count) caps))
                     (max-count (ftype-ref vk:surface-capabilities-khr (max-image-count) caps))
                     (count (if (zero? max-count) (+ min-count 1) (min (+ min-count 1) max-count)))
                     (alpha-modes (ftype-ref vk:surface-capabilities-khr (supported-composite-alpha) caps))
                     (alpha (if (zero? (bitwise-and alpha-modes vk:composite-alpha-opaque-bit-khr))
                                (bitwise-and alpha-modes (- alpha-modes))
                                vk:composite-alpha-opaque-bit-khr))
                     (info (new vk:swapchain-create-info-khr
                                (s-type vk:structure-type-swapchain-create-info-khr)
                                (surface surface)
                                (min-image-count count)
                                (image-format surface-format)
                                (image-color-space color-space)
                                (image-extent width w)
                                (image-extent height h)
                                (image-array-layers 1)
                                (image-usage vk:image-usage-color-attachment-bit)
                                (image-sharing-mode vk:sharing-mode-exclusive)
                                (pre-transform (ftype-ref vk:surface-capabilities-khr (current-transform) caps))
                                (composite-alpha alpha)
                                (present-mode present-mode)
                                (clipped vk:true)
                                (old-swapchain swapchain)))
                     (new-swapchain (create 'vkCreateSwapchainKHR
                                            (lambda (out) (vk:create-swapchain-khr device (addr info) 0 out)))))
                (destroy-swapchain-resources)
                (unless (zero? swapchain) (vk:destroy-swapchain-khr device swapchain 0))
                (set! swapchain new-swapchain)
                (set! extent-width w)
                (set! extent-height h)
                (let-values (((n images) (enumerate-array uptr (lambda (c p) (vk:get-swapchain-images-khr device swapchain c p)))))
                  (set! swapchain-images (list->vector (let loop ((i (- n 1)) (acc '()))
                                                         (if (< i 0) acc (loop (- i 1) (cons (ftype-ref uptr () images i) acc)))))))
                (set! swapchain-views (vector-map (lambda (img) (create-view img surface-format vk:image-aspect-color-bit 1))
                                                  swapchain-images))
                (set! render-done (vector-map (lambda (img) (create-semaphore)) swapchain-images))
                (let ((image-info (new vk:image-create-info
                                       (s-type vk:structure-type-image-create-info)
                                       (image-type vk:image-type-2d)
                                       (format depth-format)
                                       (extent width w) (extent height h) (extent depth 1)
                                       (mip-levels 1)
                                       (array-layers 1)
                                       (samples vk:sample-count-1-bit)
                                       (tiling vk:image-tiling-optimal)
                                       (usage vk:image-usage-depth-stencil-attachment-bit)
                                       (sharing-mode vk:sharing-mode-exclusive)
                                       (initial-layout vk:image-layout-undefined)))
                      (reqs (new-array vk:memory-requirements 1)))
                  (set! depth-image (create 'vkCreateImage (lambda (out) (vk:create-image device (addr image-info) 0 out))))
                  (vk:get-image-memory-requirements device depth-image (addr reqs))
                  (set! depth-memory (allocate-memory reqs vk:memory-property-device-local-bit))
                  (check 'vkBindImageMemory (vk:bind-image-memory device depth-image depth-memory 0))
                  (set! depth-view (create-view depth-image depth-format vk:image-aspect-depth-bit 1)))
                #t)))))))

;;; ------------------------------------------------------------------
;;; Per-frame objects and structures reused every frame.

(define command-buffers
  (with-scratch
   (let ((info (new vk:command-buffer-allocate-info
                    (s-type vk:structure-type-command-buffer-allocate-info)
                    (command-pool command-pool)
                    (level vk:command-buffer-level-primary)
                    (command-buffer-count frames-in-flight)))
         (out (new-array uptr frames-in-flight)))
     (check 'vkAllocateCommandBuffers (vk:allocate-command-buffers device (addr info) (addr out)))
     (vector-map (lambda (i) (ftype-ref uptr () out i)) (list->vector (iota frames-in-flight))))))

(define fences
  (vector-map (lambda (i)
                (with-scratch
                 (let ((info (new vk:fence-create-info
                                  (s-type vk:structure-type-fence-create-info)
                                  (flags vk:fence-create-signaled-bit))))
                   (create 'vkCreateFence (lambda (out) (vk:create-fence device (addr info) 0 out))))))
              (list->vector (iota frames-in-flight))))

(define image-acquired (vector-map (lambda (i) (create-semaphore)) (list->vector (iota frames-in-flight))))

(define begin-info (new vk:command-buffer-begin-info
                        (s-type vk:structure-type-command-buffer-begin-info)
                        (flags vk:command-buffer-usage-one-time-submit-bit)))

(define to-attachment (new-array vk:image-memory-barrier2 2))
(define to-present (new-array vk:image-memory-barrier2 1))

(define (init-barrier! p i src-stage src-access dst-stage dst-access old new aspect)
  (ftype-set! vk:image-memory-barrier2 (s-type) p i vk:structure-type-image-memory-barrier-2)
  (ftype-set! vk:image-memory-barrier2 (src-stage-mask) p i src-stage)
  (ftype-set! vk:image-memory-barrier2 (src-access-mask) p i src-access)
  (ftype-set! vk:image-memory-barrier2 (dst-stage-mask) p i dst-stage)
  (ftype-set! vk:image-memory-barrier2 (dst-access-mask) p i dst-access)
  (ftype-set! vk:image-memory-barrier2 (old-layout) p i old)
  (ftype-set! vk:image-memory-barrier2 (new-layout) p i new)
  (ftype-set! vk:image-memory-barrier2 (src-queue-family-index) p i vk:queue-family-ignored)
  (ftype-set! vk:image-memory-barrier2 (dst-queue-family-index) p i vk:queue-family-ignored)
  (ftype-set! vk:image-memory-barrier2 (subresource-range aspect-mask) p i aspect)
  (ftype-set! vk:image-memory-barrier2 (subresource-range level-count) p i 1)
  (ftype-set! vk:image-memory-barrier2 (subresource-range layer-count) p i 1))

(define depth-stages (bitwise-ior vk:pipeline-stage-2-early-fragment-tests-bit
                                  vk:pipeline-stage-2-late-fragment-tests-bit))

(init-barrier! to-attachment 0
               vk:pipeline-stage-2-color-attachment-output-bit vk:access-2-none
               vk:pipeline-stage-2-color-attachment-output-bit vk:access-2-color-attachment-write-bit
               vk:image-layout-undefined vk:image-layout-color-attachment-optimal
               vk:image-aspect-color-bit)
(init-barrier! to-attachment 1
               depth-stages vk:access-2-depth-stencil-attachment-write-bit
               depth-stages (bitwise-ior vk:access-2-depth-stencil-attachment-read-bit
                                         vk:access-2-depth-stencil-attachment-write-bit)
               vk:image-layout-undefined vk:image-layout-depth-attachment-optimal
               vk:image-aspect-depth-bit)
(init-barrier! to-present 0
               vk:pipeline-stage-2-color-attachment-output-bit vk:access-2-color-attachment-write-bit
               vk:pipeline-stage-2-none vk:access-2-none
               vk:image-layout-color-attachment-optimal vk:image-layout-present-src-khr
               vk:image-aspect-color-bit)

(define to-attachment-dependency (new vk:dependency-info
                                      (s-type vk:structure-type-dependency-info)
                                      (image-memory-barrier-count 2)
                                      (p-image-memory-barriers (addr to-attachment))))
(define to-present-dependency (new vk:dependency-info
                                   (s-type vk:structure-type-dependency-info)
                                   (image-memory-barrier-count 1)
                                   (p-image-memory-barriers (addr to-present))))

(define color-attachment (new vk:rendering-attachment-info
                              (s-type vk:structure-type-rendering-attachment-info)
                              (image-layout vk:image-layout-color-attachment-optimal)
                              (load-op vk:attachment-load-op-clear)
                              (store-op vk:attachment-store-op-store)
                              (clear-value color float32 0 0.02)
                              (clear-value color float32 1 0.02)
                              (clear-value color float32 2 0.03)
                              (clear-value color float32 3 1.0)))
(define depth-attachment (new vk:rendering-attachment-info
                              (s-type vk:structure-type-rendering-attachment-info)
                              (image-layout vk:image-layout-depth-attachment-optimal)
                              (load-op vk:attachment-load-op-clear)
                              (store-op vk:attachment-store-op-dont-care)
                              (clear-value depth-stencil depth 1.0)))
(define rendering-info (new vk:rendering-info
                            (s-type vk:structure-type-rendering-info)
                            (layer-count 1)
                            (color-attachment-count 1)
                            (p-color-attachments (addr color-attachment))
                            (p-depth-attachment (addr depth-attachment))))
(define viewport (new vk:viewport (min-depth 0.0) (max-depth 1.0)))
(define scissor (new-array vk:rect2-d 1))
(define vertex-buffers (new-array uptr 1))
(ftype-set! uptr () vertex-buffers vertex-buffer)
(define vertex-offsets (new-array unsigned-64 1))
(define descriptor-sets (new-array uptr 1))
(ftype-set! uptr () descriptor-sets descriptor-set)
(define push-constants (malloc push-constant-size))

(define wait-stage (new-array unsigned-32 1))
(ftype-set! unsigned-32 () wait-stage vk:pipeline-stage-color-attachment-output-bit)
(define submit-wait (new-array uptr 1))
(define submit-signal (new-array uptr 1))
(define submit-command-buffer (new-array uptr 1))
(define submit-info (new vk:submit-info
                         (s-type vk:structure-type-submit-info)
                         (wait-semaphore-count 1)
                         (p-wait-semaphores (addr submit-wait))
                         (p-wait-dst-stage-mask (addr wait-stage))
                         (command-buffer-count 1)
                         (p-command-buffers (addr submit-command-buffer))
                         (signal-semaphore-count 1)
                         (p-signal-semaphores (addr submit-signal))))
(define present-swapchain (new-array uptr 1))
(define present-index (new-array unsigned-32 1))
(define present-info (new vk:present-info-khr
                          (s-type vk:structure-type-present-info-khr)
                          (wait-semaphore-count 1)
                          (p-wait-semaphores (addr submit-signal))
                          (swapchain-count 1)
                          (p-swapchains (addr present-swapchain))
                          (p-image-indices (addr present-index))))
(define fence-slot (new-array uptr 1))
(define image-index-slot (new-array unsigned-32 1))

;;; ------------------------------------------------------------------
;;; Drawing.

(define spin 0.0)        ; degrees around Y, advanced over time
(define tilt-x 25.0)     ; arrow keys
(define tilt-y 0.0)

(define (record! cmd image-index)
  (check 'vkResetCommandBuffer (vk:reset-command-buffer cmd 0))
  (check 'vkBeginCommandBuffer (vk:begin-command-buffer cmd (addr begin-info)))
  (ftype-set! vk:image-memory-barrier2 (image) to-attachment 0 (vector-ref swapchain-images image-index))
  (ftype-set! vk:image-memory-barrier2 (image) to-attachment 1 depth-image)
  (ftype-set! vk:image-memory-barrier2 (image) to-present 0 (vector-ref swapchain-images image-index))
  (vk:cmd-pipeline-barrier2 cmd (addr to-attachment-dependency))
  (ftype-set! vk:rendering-attachment-info (image-view) color-attachment (vector-ref swapchain-views image-index))
  (ftype-set! vk:rendering-attachment-info (image-view) depth-attachment depth-view)
  (ftype-set! vk:rendering-info (render-area extent width) rendering-info extent-width)
  (ftype-set! vk:rendering-info (render-area extent height) rendering-info extent-height)
  (vk:cmd-begin-rendering cmd (addr rendering-info))
  (ftype-set! vk:viewport (y) viewport (inexact extent-height))
  (ftype-set! vk:viewport (width) viewport (inexact extent-width))
  (ftype-set! vk:viewport (height) viewport (inexact (- extent-height)))
  (vk:cmd-set-viewport cmd 0 1 (addr viewport))
  (ftype-set! vk:rect2-d (extent width) scissor extent-width)
  (ftype-set! vk:rect2-d (extent height) scissor extent-height)
  (vk:cmd-set-scissor cmd 0 1 (addr scissor))
  (vk:cmd-bind-pipeline cmd vk:pipeline-bind-point-graphics pipeline)
  (vk:cmd-bind-descriptor-sets cmd vk:pipeline-bind-point-graphics pipeline-layout 0 1 (addr descriptor-sets) 0 0)
  (vk:cmd-bind-vertex-buffers cmd 0 1 (addr vertex-buffers) (addr vertex-offsets))
  (let* ((projection (perspective 45.0 (/ (inexact extent-width) extent-height) 0.1 100.0))
         (modelview (mat* (translate 0 0 -5)
                          (mat* (rotate-x tilt-x) (mat* (rotate-y tilt-y) (rotate-y spin))))))
    (write-matrix! push-constants 0 (mat* projection modelview))
    (write-normal-matrix! push-constants 64 modelview))
  (vk:cmd-push-constants cmd pipeline-layout vk:shader-stage-vertex-bit 0 push-constant-size push-constants)
  (vk:cmd-draw cmd vertex-count 1 0 0)
  (vk:cmd-end-rendering cmd)
  (vk:cmd-pipeline-barrier2 cmd (addr to-present-dependency))
  (check 'vkEndCommandBuffer (vk:end-command-buffer cmd)))

(define swapchain-stale? (not (create-swapchain!)))

;; Draw one frame.  Returns #t if a frame was drawn, #f to retry at once
;; (the swapchain was out of date), or 'idle when no swapchain can be made
;; (the window is minimized).
(define (draw-frame! frame)
  (let-values (((fb-w fb-h) (glfw-framebuffer-size window)))
    (unless (and (= fb-w extent-width) (= fb-h extent-height))
      (set! swapchain-stale? #t)))
  (when swapchain-stale?
    (check 'vkDeviceWaitIdle (vk:device-wait-idle device))
    (set! swapchain-stale? (not (create-swapchain!))))
  (if swapchain-stale?
      'idle
       (let ((fence (vector-ref fences frame))
             (cmd (vector-ref command-buffers frame)))
         (ftype-set! uptr () fence-slot fence)
         (check 'vkWaitForFences (vk:wait-for-fences device 1 (addr fence-slot) vk:true -1))
         (let ((r (vk:acquire-next-image-khr device swapchain -1 (vector-ref image-acquired frame) 0
                                             (addr image-index-slot))))
           (cond
            ((= r vk:error-out-of-date-khr) (set! swapchain-stale? #t) #f)
            ((not (memv r (list vk:success vk:suboptimal-khr))) (check 'vkAcquireNextImageKHR r))
            (else
             (let ((index (ftype-ref unsigned-32 () image-index-slot)))
               (check 'vkResetFences (vk:reset-fences device 1 (addr fence-slot)))
               (record! cmd index)
               (ftype-set! uptr () submit-wait (vector-ref image-acquired frame))
               (ftype-set! uptr () submit-signal (vector-ref render-done index))
               (ftype-set! uptr () submit-command-buffer cmd)
               (check 'vkQueueSubmit (vk:queue-submit queue 1 (addr submit-info) fence))
               (ftype-set! uptr () present-swapchain swapchain)
               (ftype-set! unsigned-32 () present-index index)
               (let ((p (vk:queue-present-khr queue (addr present-info))))
                 (cond ((memv p (list vk:error-out-of-date-khr vk:suboptimal-khr)) (set! swapchain-stale? #t))
                       (else (check 'vkQueuePresentKHR p))))
               (when (= r vk:suboptimal-khr) (set! swapchain-stale? #t))
               #t)))))))

;;; ------------------------------------------------------------------
;;; Main loop.

(define paused? #f)
(define space-was-down? #f)

(define (handle-input! dt)
  (when (glfw-key-pressed? window glfw-key-escape) (glfw-set-window-should-close! window))
  (let ((space (glfw-key-pressed? window glfw-key-space)))
    (when (and space (not space-was-down?)) (set! paused? (not paused?)))
    (set! space-was-down? space))
  (let ((step (* 90.0 dt)))             ; degrees per second while held
    (when (glfw-key-pressed? window glfw-key-up) (set! tilt-x (- tilt-x step)))
    (when (glfw-key-pressed? window glfw-key-down) (set! tilt-x (+ tilt-x step)))
    (when (glfw-key-pressed? window glfw-key-left) (set! tilt-y (- tilt-y step)))
    (when (glfw-key-pressed? window glfw-key-right) (set! tilt-y (+ tilt-y step)))))

(let loop ((frame 0) (frames 0) (total-frames 0) (last (glfw-time)) (report-start (glfw-time)))
  (glfw-poll-events)
  (when (and (not (glfw-window-should-close? window))
             (not (and frame-limit (>= total-frames frame-limit))))
    (let* ((t (glfw-time)) (dt (- t last)))
      (handle-input! dt)
      (unless paused?
        (set! spin (let ((a (+ spin (if spin-step (inexact spin-step) (* 45.0 dt)))))
                     (if (>= a 360.0) (- a 360.0) a))))
      (let* ((result (draw-frame! frame))
             (drawn (eq? result #t))
             (frames (if drawn (+ frames 1) frames))
             (total-frames (if drawn (+ total-frames 1) total-frames))
             (next (if drawn (modulo (+ frame 1) frames-in-flight) frame)))
        (when (eq? result 'idle) (glfw-wait-events))   ; minimized: sleep until something happens
        (if (>= (- t report-start) 5.0)
            (begin
              (printf "~a frames in ~,1f seconds = ~,3f FPS\n"
                      frames (- t report-start) (/ frames (- t report-start)))
              (flush-output-port (current-output-port))
              (loop next 0 total-frames t t))
            (loop next frames total-frames t report-start))))))

;;; ------------------------------------------------------------------
;;; Clean up.

(check 'vkDeviceWaitIdle (vk:device-wait-idle device))
(vector-for-each (lambda (s) (vk:destroy-semaphore device s 0)) image-acquired)
(vector-for-each (lambda (f) (vk:destroy-fence device f 0)) fences)
(destroy-swapchain-resources)
(unless (zero? swapchain) (vk:destroy-swapchain-khr device swapchain 0))
(vk:destroy-pipeline device pipeline 0)
(vk:destroy-pipeline-layout device pipeline-layout 0)
(vk:destroy-descriptor-pool device descriptor-pool 0)
(vk:destroy-descriptor-set-layout device set-layout 0)
(vk:destroy-sampler device sampler 0)
(vk:destroy-image-view device texture-view 0)
(vk:destroy-image device texture-image 0)
(vk:free-memory device texture-memory 0)
(vk:destroy-buffer device vertex-buffer 0)
(vk:free-memory device vertex-memory 0)
(vk:destroy-command-pool device command-pool 0)
(vk:destroy-device device 0)
(vk:destroy-surface-khr instance surface 0)
(vk:destroy-instance instance 0)
(glfw-destroy-window window)
(glfw-terminate)
(free-all)
