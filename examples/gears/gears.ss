;;; chezgears: three spinning gears, the classic OpenGL demo redone on
;;; Vulkan with an X11 window.  Needs only Chez Scheme, the Vulkan loader
;;; and libX11 (XWayland on Wayland desktops).
;;;
;;; Run from the repository root:
;;;
;;;   scheme --script examples/gears/gears.ss [--device N] [--novsync] [--frames N]
;;;
;;; Keys: arrows rotate the view, z / Z rotate around the view axis, Esc quits.
;;; Shaders: glslangValidator -V examples/gears/gears.vert -o examples/gears/gears.vert.spv
;;;          glslangValidator -V examples/gears/gears.frag -o examples/gears/gears.frag.spv

(load "vulkan.ss")
(load "constants.ss")
(load "xlib.ss")
(load "examples/common.ss")
(load "examples/x11.ss")
(load "examples/math.ss")
(import (vulkan) (vulkan constants) (vulkan xlib) (examples common) (examples x11) (examples math))

;;; ------------------------------------------------------------------
;;; Options.

(define (option name default convert)
  (let loop ((args (command-line-arguments)))
    (cond ((null? args) default)
          ((string=? (car args) name)
           (if convert
               (if (pair? (cdr args)) (convert (cadr args)) (error 'gears "missing value" name))
               #t))
          (else (loop (cdr args))))))

(define device-choice (option "--device" #f string->number))
(define no-vsync? (option "--novsync" #f #f))
(define frame-limit (option "--frames" #f string->number))
(define frames-in-flight 2)

;;; ------------------------------------------------------------------
;;; Gear geometry: the classic gear() routine, emitted as triangles.  Each
;;; vertex is (x y z nx ny nz).  Faces that the original drew flat-shaded get
;;; one normal per triangle; the inner cylinder keeps per-vertex normals.

(define (gear-triangles inner-radius outer-radius width teeth tooth-depth)
  (let* ((r0 inner-radius)
         (r1 (- outer-radius (/ tooth-depth 2.0)))
         (r2 (+ outer-radius (/ tooth-depth 2.0)))
         (da (/ (* 2.0 pi) teeth 4.0))
         (hw (/ width 2.0))
         (out '()))
    (define (angle i) (/ (* i 2.0 pi) teeth))
    (define (p r a z) (list (* r (cos a)) (* r (sin a)) z))
    (define (emit! v n) (set! out (cons (append v n) out)))
    (define (tri! a b c n) (emit! a n) (emit! b n) (emit! c n))
    (define (quad! a b c d n) (tri! a b c n) (tri! a c d n))
    ;; GL quad strip: quad k is v2k v2k+1 v2k+3 v2k+2; flat shading takes the
    ;; normal of v2k+3.  Strip entries are (vertex . normal).
    (define (strip! vs flat?)
      (let loop ((vs vs))
        (when (>= (length vs) 4)
          (let ((a (list-ref vs 0)) (b (list-ref vs 1))
                (c (list-ref vs 3)) (d (list-ref vs 2)))
            (if flat?
                (quad! (car a) (car b) (car c) (car d) (cdr c))
                (begin (emit! (car a) (cdr a)) (emit! (car b) (cdr b)) (emit! (car c) (cdr c))
                       (emit! (car a) (cdr a)) (emit! (car c) (cdr c)) (emit! (car d) (cdr d)))))
          (loop (cddr vs)))))
    (define front '(0.0 0.0 1.0))
    (define back '(0.0 0.0 -1.0))
    ;; front face
    (strip! (let loop ((i 0) (acc '()))
              (if (> i teeth)
                  (reverse acc)
                  (let* ((a (angle i))
                         (acc (cons* (cons (p r1 a hw) front) (cons (p r0 a hw) front) acc)))
                    (loop (+ i 1)
                          (if (< i teeth)
                              (cons* (cons (p r1 (+ a (* 3 da)) hw) front) (cons (p r0 a hw) front) acc)
                              acc)))))
            #t)
    ;; front sides of teeth
    (do ((i 0 (+ i 1))) ((= i teeth))
      (let ((a (angle i)))
        (quad! (p r1 a hw) (p r2 (+ a da) hw) (p r2 (+ a (* 2 da)) hw) (p r1 (+ a (* 3 da)) hw) front)))
    ;; back face
    (strip! (let loop ((i 0) (acc '()))
              (if (> i teeth)
                  (reverse acc)
                  (let* ((a (angle i))
                         (acc (cons* (cons (p r0 a (- hw)) back) (cons (p r1 a (- hw)) back) acc)))
                    (loop (+ i 1)
                          (if (< i teeth)
                              (cons* (cons (p r0 a (- hw)) back) (cons (p r1 (+ a (* 3 da)) (- hw)) back) acc)
                              acc)))))
            #t)
    ;; back sides of teeth
    (do ((i 0 (+ i 1))) ((= i teeth))
      (let ((a (angle i)))
        (quad! (p r1 (+ a (* 3 da)) (- hw)) (p r2 (+ a (* 2 da)) (- hw))
               (p r2 (+ a da) (- hw)) (p r1 a (- hw)) back)))
    ;; outward faces of teeth
    (strip! (let loop ((i 0) (acc '()) (n back))
              (define (pair r a n acc) (cons* (cons (p r a (- hw)) n) (cons (p r a hw) n) acc))
              (define (flank r-from a-from r-to a-to)
                (let* ((u (- (* r-to (cos a-to)) (* r-from (cos a-from))))
                       (v (- (* r-to (sin a-to)) (* r-from (sin a-from))))
                       (len (sqrt (+ (* u u) (* v v)))))
                  (list (/ v len) (/ (- u) len) 0.0)))
              (if (= i teeth)
                  (reverse (pair r1 0.0 n acc))
                  (let* ((a (angle i))
                         (radial (list (cos a) (sin a) 0.0))
                         (acc (pair r1 a n acc))
                         (acc (pair r2 (+ a da) (flank r1 a r2 (+ a da)) acc))
                         (acc (pair r2 (+ a (* 2 da)) radial acc))
                         (acc (pair r1 (+ a (* 3 da)) (flank r2 (+ a (* 2 da)) r1 (+ a (* 3 da))) acc)))
                    (loop (+ i 1) acc radial))))
            #t)
    ;; inside radius cylinder (smooth shaded)
    (strip! (let loop ((i 0) (acc '()))
              (if (> i teeth)
                  (reverse acc)
                  (let* ((a (angle i)) (n (list (- (cos a)) (- (sin a)) 0.0)))
                    (loop (+ i 1) (cons* (cons (p r0 a hw) n) (cons (p r0 a (- hw)) n) acc)))))
            #f)
    (reverse out)))

;; name, color, gear parameters, position, angle = scale * angle + offset
(define gear-specs
  `((red   (0.8 0.1 0.0 1.0) (1.0 4.0 1.0 20 0.7) (-3.0 -2.0) 1.0 0.0)
    (green (0.0 0.8 0.2 1.0) (0.5 2.0 2.0 10 0.7) (3.1 -2.0) -2.0 -9.0)
    (blue  (0.2 0.2 1.0 1.0) (1.3 2.0 0.5 10 0.7) (-3.1 4.2) -2.0 -25.0)))

;;; ------------------------------------------------------------------
;;; Window, instance, surface.

(define window (x11-open-window "chezgears" 300 300))

(define instance
  (let* ((app (new vk:application-info
                   (s-type vk:structure-type-application-info)
                   (p-application-name (c-string "chezgears"))
                   (application-version 1)
                   (api-version vk:api-version-1-3)))
         (extensions '("VK_KHR_surface" "VK_KHR_xlib_surface"))
         (info (new vk:instance-create-info
                    (s-type vk:structure-type-instance-create-info)
                    (p-application-info (addr app))
                    (enabled-extension-count (length extensions))
                    (pp-enabled-extension-names (c-string-array extensions)))))
    (create 'vkCreateInstance (lambda (out) (vk:create-instance (addr info) 0 out)))))

(define surface
  (let ((info (new vk:xlib-surface-create-info-khr
                   (s-type vk:structure-type-xlib-surface-create-info-khr)
                   (dpy (x11-window-display window))
                   (window (x11-window-id window)))))
    (create 'vkCreateXlibSurfaceKHR
            (lambda (out) (vk:create-xlib-surface-khr instance (addr info) 0 out)))))

;;; ------------------------------------------------------------------
;;; Physical device: needs Vulkan 1.3 (dynamic rendering, synchronization2),
;;; VK_KHR_swapchain and a graphics queue that can present to the surface.

(define (device-properties pd)
  (let ((props (new-array vk:physical-device-properties 1)))
    (vk:get-physical-device-properties pd (addr props))
    (values (c-string->string (addr (ftype-&ref vk:physical-device-properties (device-name) props)))
            (ftype-ref vk:physical-device-properties (api-version) props))))

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
  (let-values (((name api) (device-properties pd)))
    (and (>= api vk:api-version-1-3)
         (has-device-extension? pd "VK_KHR_swapchain")
         (graphics-present-family pd))))

(define-values (physical-device queue-family)
  (let-values (((n devices) (enumerate-array uptr (lambda (c p) (vk:enumerate-physical-devices instance c p)))))
    (let ((candidates (if device-choice
                          (list (ftype-ref uptr () devices device-choice))
                          (let loop ((i (- n 1)) (acc '()))
                            (if (< i 0) acc (loop (- i 1) (cons (ftype-ref uptr () devices i) acc)))))))
      (let loop ((ds candidates))
        (cond ((null? ds) (error 'gears "no device with Vulkan 1.3, VK_KHR_swapchain and presentation"))
              ((usable-device (car ds)) => (lambda (q) (values (car ds) q)))
              (else (loop (cdr ds))))))))

(let-values (((name api) (device-properties physical-device)))
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
         (extensions '("VK_KHR_swapchain"))
         (info (new vk:device-create-info
                    (s-type vk:structure-type-device-create-info)
                    (p-next (addr features13))
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
;;; Memory helpers.

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

;;; ------------------------------------------------------------------
;;; Vertex buffer with all three gears (host-visible; it is written once).

(define-values (vertex-buffer vertex-memory gear-ranges)
  (let* ((meshes (map (lambda (spec) (apply gear-triangles (caddr spec))) gear-specs))
         (total (apply + (map length meshes)))
         (size (* total 6 4))
         (buffer (with-scratch
                  (let ((info (new vk:buffer-create-info
                                   (s-type vk:structure-type-buffer-create-info)
                                   (size size)
                                   (usage vk:buffer-usage-vertex-buffer-bit)
                                   (sharing-mode vk:sharing-mode-exclusive))))
                    (create 'vkCreateBuffer (lambda (out) (vk:create-buffer device (addr info) 0 out))))))
         (memory (with-scratch
                  (let ((reqs (new-array vk:memory-requirements 1)))
                    (vk:get-buffer-memory-requirements device buffer (addr reqs))
                    (allocate-memory reqs (bitwise-ior vk:memory-property-host-visible-bit
                                                       vk:memory-property-host-coherent-bit))))))
    (check 'vkBindBufferMemory (vk:bind-buffer-memory device buffer memory 0))
    (let ((mapped (with-scratch
                   (create 'vkMapMemory (lambda (out) (vk:map-memory device memory 0 vk:whole-size 0 out))))))
      (let loop ((meshes meshes) (first 0) (ranges '()))
        (if (null? meshes)
            (begin (vk:unmap-memory device memory)
                   (values buffer memory (reverse ranges)))
            (begin
              (let fill ((vs (car meshes)) (i first))
                (unless (null? vs)
                  (let put ((xs (car vs)) (j 0))
                    (unless (null? xs)
                      (foreign-set! 'float mapped (* 4 (+ (* 6 i) j)) (inexact (car xs)))
                      (put (cdr xs) (+ j 1))))
                  (fill (cdr vs) (+ i 1))))
              (loop (cdr meshes) (+ first (length (car meshes)))
                    (cons (cons first (length (car meshes))) ranges))))))))

(printf "~a triangles\n" (/ (apply + (map cdr gear-ranges)) 3))

;;; ------------------------------------------------------------------
;;; Surface format, depth format, present mode.

(define-values (surface-format color-space)
  (with-scratch
   (let-values (((n formats) (enumerate-array vk:surface-format-khr
                                        (lambda (c p) (vk:get-physical-device-surface-formats-khr
                                                       physical-device surface c p)))))
     ;; UNORM, not SRGB: the classic demo's colors were written without gamma.
     (let loop ((i 0))
       (cond ((= i n) (values (ftype-ref vk:surface-format-khr (format) formats 0)
                              (ftype-ref vk:surface-format-khr (color-space) formats 0)))
             ((memv (ftype-ref vk:surface-format-khr (format) formats i)
                    (list vk:format-b8g8r8a8-unorm vk:format-r8g8b8a8-unorm))
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

(define push-constant-size 128)

(define pipeline-layout
  (with-scratch
   (let* ((range (new vk:push-constant-range
                      (stage-flags vk:shader-stage-vertex-bit)
                      (offset 0)
                      (size push-constant-size)))
          (info (new vk:pipeline-layout-create-info
                     (s-type vk:structure-type-pipeline-layout-create-info)
                     (push-constant-range-count 1)
                     (p-push-constant-ranges (addr range)))))
     (create 'vkCreatePipelineLayout (lambda (out) (vk:create-pipeline-layout device (addr info) 0 out))))))

(define pipeline
  (let ((vert (shader-module "examples/gears/gears.vert.spv"))
        (frag (shader-module "examples/gears/gears.frag.spv")))
    (let ((p (with-scratch
              (let* ((main (c-string "main"))
                     (stages (new-array vk:pipeline-shader-stage-create-info 2))
                     (_ (begin
                          (ftype-set! vk:pipeline-shader-stage-create-info (s-type) stages 0
                                      vk:structure-type-pipeline-shader-stage-create-info)
                          (ftype-set! vk:pipeline-shader-stage-create-info (stage) stages 0 vk:shader-stage-vertex-bit)
                          (ftype-set! vk:pipeline-shader-stage-create-info (module) stages 0 vert)
                          (ftype-set! vk:pipeline-shader-stage-create-info (p-name) stages 0 main)
                          (ftype-set! vk:pipeline-shader-stage-create-info (s-type) stages 1
                                      vk:structure-type-pipeline-shader-stage-create-info)
                          (ftype-set! vk:pipeline-shader-stage-create-info (stage) stages 1 vk:shader-stage-fragment-bit)
                          (ftype-set! vk:pipeline-shader-stage-create-info (module) stages 1 frag)
                          (ftype-set! vk:pipeline-shader-stage-create-info (p-name) stages 1 main)))
                     (binding (new vk:vertex-input-binding-description
                                   (binding 0) (stride 24) (input-rate vk:vertex-input-rate-vertex)))
                     (attributes (new-array vk:vertex-input-attribute-description 2))
                     (_ (begin
                          (ftype-set! vk:vertex-input-attribute-description (location) attributes 0 0)
                          (ftype-set! vk:vertex-input-attribute-description (format) attributes 0 vk:format-r32g32b32-sfloat)
                          (ftype-set! vk:vertex-input-attribute-description (offset) attributes 0 0)
                          (ftype-set! vk:vertex-input-attribute-description (location) attributes 1 1)
                          (ftype-set! vk:vertex-input-attribute-description (format) attributes 1 vk:format-r32g32b32-sfloat)
                          (ftype-set! vk:vertex-input-attribute-description (offset) attributes 1 12)))
                     (vertex-input (new vk:pipeline-vertex-input-state-create-info
                                        (s-type vk:structure-type-pipeline-vertex-input-state-create-info)
                                        (vertex-binding-description-count 1)
                                        (p-vertex-binding-descriptions (addr binding))
                                        (vertex-attribute-description-count 2)
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
;;; Swapchain and everything sized to it: image views, the depth buffer
;;; and one "rendering finished" semaphore per image.

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

(define (create-view image format aspect)
  (with-scratch
   (let ((info (new vk:image-view-create-info
                    (s-type vk:structure-type-image-view-create-info)
                    (image image)
                    (view-type vk:image-view-type-2d)
                    (format format)
                    (subresource-range aspect-mask aspect)
                    (subresource-range level-count 1)
                    (subresource-range layer-count 1))))
     (create 'vkCreateImageView (lambda (out) (vk:create-image-view device (addr info) 0 out))))))

(define (destroy-swapchain-resources)
  (vector-for-each (lambda (v) (vk:destroy-image-view device v 0)) swapchain-views)
  (vector-for-each (lambda (s) (vk:destroy-semaphore device s 0)) render-done)
  (unless (zero? depth-view)
    (vk:destroy-image-view device depth-view 0)
    (vk:destroy-image device depth-image 0)
    (vk:free-memory device depth-memory 0)))

;; Returns #f when the window has no area (minimized), #t otherwise.
(define (create-swapchain!)
  (with-scratch
   (let ((caps (new-array vk:surface-capabilities-khr 1)))
     (check 'vkGetPhysicalDeviceSurfaceCapabilitiesKHR
            (vk:get-physical-device-surface-capabilities-khr physical-device surface (addr caps)))
     (let* ((current-w (ftype-ref vk:surface-capabilities-khr (current-extent width) caps))
            (clamp (lambda (v lo hi) (max lo (min hi v))))
            (w (if (= current-w #xFFFFFFFF)
                   (clamp (car (x11-window-size window))
                          (ftype-ref vk:surface-capabilities-khr (min-image-extent width) caps)
                          (ftype-ref vk:surface-capabilities-khr (max-image-extent width) caps))
                   current-w))
            (h (if (= current-w #xFFFFFFFF)
                   (clamp (cdr (x11-window-size window))
                          (ftype-ref vk:surface-capabilities-khr (min-image-extent height) caps)
                          (ftype-ref vk:surface-capabilities-khr (max-image-extent height) caps))
                   (ftype-ref vk:surface-capabilities-khr (current-extent height) caps))))
       (and (> w 0) (> h 0)
            (let* ((min-count (ftype-ref vk:surface-capabilities-khr (min-image-count) caps))
                   (max-count (ftype-ref vk:surface-capabilities-khr (max-image-count) caps))
                   (count (if (zero? max-count) (+ min-count 1) (min (+ min-count 1) max-count)))
                   (alpha-modes (ftype-ref vk:surface-capabilities-khr (supported-composite-alpha) caps))
                   (alpha (if (zero? (bitwise-and alpha-modes vk:composite-alpha-opaque-bit-khr))
                              (bitwise-and alpha-modes (- alpha-modes)) ; lowest supported bit
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
              (set! swapchain-views (vector-map (lambda (img) (create-view img surface-format vk:image-aspect-color-bit))
                                                swapchain-images))
              (set! render-done (vector-map (lambda (img) (create-semaphore)) swapchain-images))
              ;; depth buffer
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
                (set! depth-view (create-view depth-image depth-format vk:image-aspect-depth-bit)))
              #t))))))

;;; ------------------------------------------------------------------
;;; Per-frame objects: command buffer, fence, "image acquired" semaphore.

(define command-pool
  (with-scratch
   (let ((info (new vk:command-pool-create-info
                    (s-type vk:structure-type-command-pool-create-info)
                    (flags vk:command-pool-create-reset-command-buffer-bit)
                    (queue-family-index queue-family))))
     (create 'vkCreateCommandPool (lambda (out) (vk:create-command-pool device (addr info) 0 out))))))

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

;;; ------------------------------------------------------------------
;;; Structures reused every frame (allocated once, fields updated per frame).

(define begin-info (new vk:command-buffer-begin-info
                        (s-type vk:structure-type-command-buffer-begin-info)
                        (flags vk:command-buffer-usage-one-time-submit-bit)))

;; [0] swapchain image -> color attachment, [1] depth -> depth attachment
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
                              (store-op vk:attachment-store-op-store)))
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

(define view-rot-x 20.0)
(define view-rot-y 30.0)
(define view-rot-z 0.0)
(define angle 0.0)

(define (write-push-constants! mvp modelview color)
  (write-matrix! push-constants 0 mvp)
  (write-normal-matrix! push-constants 64 modelview)
  (let loop ((i 0) (color color))
    (unless (null? color)
      (foreign-set! 'float push-constants (+ 112 (* 4 i)) (inexact (car color)))
      (loop (+ i 1) (cdr color)))))

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
  ;; Flipped viewport: y up, as in OpenGL.
  (ftype-set! vk:viewport (y) viewport (inexact extent-height))
  (ftype-set! vk:viewport (width) viewport (inexact extent-width))
  (ftype-set! vk:viewport (height) viewport (inexact (- extent-height)))
  (vk:cmd-set-viewport cmd 0 1 (addr viewport))
  (ftype-set! vk:rect2-d (extent width) scissor extent-width)
  (ftype-set! vk:rect2-d (extent height) scissor extent-height)
  (vk:cmd-set-scissor cmd 0 1 (addr scissor))
  (vk:cmd-bind-pipeline cmd vk:pipeline-bind-point-graphics pipeline)
  (vk:cmd-bind-vertex-buffers cmd 0 1 (addr vertex-buffers) (addr vertex-offsets))
  (let* ((h (/ (inexact extent-height) extent-width))
         (projection (frustum -1.0 1.0 (- h) h 5.0 60.0))
         (view (mat* (translate 0 0 -40)
                     (mat* (rotate-x view-rot-x) (mat* (rotate-y view-rot-y) (rotate-z view-rot-z))))))
    (for-each (lambda (spec range)
                (let* ((color (cadr spec))
                       (position (cadddr spec))
                       (gear-angle (+ (* (list-ref spec 4) angle) (list-ref spec 5)))
                       (modelview (mat* view (mat* (translate (car position) (cadr position) 0)
                                                   (rotate-z gear-angle)))))
                  (write-push-constants! (mat* projection modelview) modelview color)
                  (vk:cmd-push-constants cmd pipeline-layout vk:shader-stage-vertex-bit
                                         0 push-constant-size push-constants)
                  (vk:cmd-draw cmd (cdr range) 1 (car range) 0)))
              gear-specs gear-ranges))
  (vk:cmd-end-rendering cmd)
  (vk:cmd-pipeline-barrier2 cmd (addr to-present-dependency))
  (check 'vkEndCommandBuffer (vk:end-command-buffer cmd)))

(define swapchain-stale? (not (create-swapchain!)))

;; Draw one frame.  Returns #f if nothing was drawn (minimized window).
(define (draw-frame! frame)
  (when swapchain-stale?
    (check 'vkDeviceWaitIdle (vk:device-wait-idle device))
    (set! swapchain-stale? (not (create-swapchain!))))
  (and (not swapchain-stale?)
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

(define (now)
  (let ((t (current-time 'time-monotonic)))
    (+ (time-second t) (/ (time-nanosecond t) 1e9))))

(define (on-key keysym)
  (cond ((= keysym xk-escape) (set! running #f))
        ((= keysym xk-left) (set! view-rot-y (+ view-rot-y 5.0)))
        ((= keysym xk-right) (set! view-rot-y (- view-rot-y 5.0)))
        ((= keysym xk-up) (set! view-rot-x (+ view-rot-x 5.0)))
        ((= keysym xk-down) (set! view-rot-x (- view-rot-x 5.0)))
        ((= keysym (char->integer #\z)) (set! view-rot-z (+ view-rot-z 5.0)))
        ((= keysym (char->integer #\Z)) (set! view-rot-z (- view-rot-z 5.0)))))

(define (on-resize width height) (set! swapchain-stale? #t))

(define running #t)

(let loop ((frame 0) (frames 0) (total-frames 0) (last (now)) (report-start (now)))
  (when (and running (x11-poll-events window on-key on-resize)
             (not (and frame-limit (>= total-frames frame-limit))))
    (let* ((t (now)) (dt (- t last)))
      (set! angle (let ((a (+ angle (* 70.0 dt)))) (if (> a 3600.0) (- a 3600.0) a)))
      (let ((drawn (draw-frame! frame)))
        (let ((frames (if drawn (+ frames 1) frames))
              (total-frames (if drawn (+ total-frames 1) total-frames)))
          (if (>= (- t report-start) 5.0)
              (begin
                (printf "~a frames in ~,1f seconds = ~,3f FPS\n"
                        frames (- t report-start) (/ frames (- t report-start)))
                (flush-output-port (current-output-port))
                (loop (if drawn (modulo (+ frame 1) frames-in-flight) frame) 0 total-frames t t))
              (loop (if drawn (modulo (+ frame 1) frames-in-flight) frame)
                    frames total-frames t report-start)))))))

;;; ------------------------------------------------------------------
;;; Clean up.

(check 'vkDeviceWaitIdle (vk:device-wait-idle device))
(vector-for-each (lambda (s) (vk:destroy-semaphore device s 0)) image-acquired)
(vector-for-each (lambda (f) (vk:destroy-fence device f 0)) fences)
(vk:destroy-command-pool device command-pool 0)
(destroy-swapchain-resources)
(unless (zero? swapchain) (vk:destroy-swapchain-khr device swapchain 0))
(vk:destroy-pipeline device pipeline 0)
(vk:destroy-pipeline-layout device pipeline-layout 0)
(vk:destroy-buffer device vertex-buffer 0)
(vk:free-memory device vertex-memory 0)
(vk:destroy-device device 0)
(vk:destroy-surface-khr instance surface 0)
(vk:destroy-instance instance 0)
(x11-close-window window)
(free-all)
