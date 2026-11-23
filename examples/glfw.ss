;;; Minimal GLFW 3 bindings for the examples (libglfw.so.3).  Input is
;;; polled (glfwGetKey, glfwGetFramebufferSize) rather than delivered
;;; through callbacks, so no foreign-callable code is needed.  GLFW 3.4+
;;; picks Wayland or X11 at run time.

(library (examples glfw)
  (export glfw-init glfw-terminate
          glfw-create-window glfw-destroy-window
          glfw-window-should-close? glfw-set-window-should-close!
          glfw-poll-events glfw-wait-events glfw-time
          glfw-framebuffer-size glfw-key-pressed?
          glfw-required-instance-extensions glfw-create-window-surface
          glfw-key-escape glfw-key-space glfw-key-left glfw-key-right
          glfw-key-up glfw-key-down)
  (import (chezscheme))

  (define libglfw (load-shared-object "libglfw.so.3"))

  ;; From GLFW/glfw3.h
  (define glfw-client-api #x00022001)
  (define glfw-no-api 0)
  (define glfw-press 1)
  (define glfw-key-space 32)
  (define glfw-key-escape 256)
  (define glfw-key-right 262)
  (define glfw-key-left 263)
  (define glfw-key-down 264)
  (define glfw-key-up 265)

  (define glfwInit (foreign-procedure "glfwInit" () int))
  (define glfwTerminate (foreign-procedure "glfwTerminate" () void))
  (define glfwGetError (foreign-procedure "glfwGetError" (uptr) int))
  (define glfwWindowHint (foreign-procedure "glfwWindowHint" (int int) void))
  (define glfwCreateWindow (foreign-procedure "glfwCreateWindow" (int int string uptr uptr) uptr))
  (define glfwDestroyWindow (foreign-procedure "glfwDestroyWindow" (uptr) void))
  (define glfwWindowShouldClose (foreign-procedure "glfwWindowShouldClose" (uptr) int))
  (define glfwSetWindowShouldClose (foreign-procedure "glfwSetWindowShouldClose" (uptr int) void))
  (define glfwPollEvents (foreign-procedure "glfwPollEvents" () void))
  (define glfwWaitEvents (foreign-procedure "glfwWaitEvents" () void))
  (define glfwGetTime (foreign-procedure "glfwGetTime" () double))
  (define glfwGetFramebufferSize (foreign-procedure "glfwGetFramebufferSize" (uptr uptr uptr) void))
  (define glfwGetKey (foreign-procedure "glfwGetKey" (uptr int) int))
  (define glfwVulkanSupported (foreign-procedure "glfwVulkanSupported" () int))
  (define glfwGetRequiredInstanceExtensions
    (foreign-procedure "glfwGetRequiredInstanceExtensions" (uptr) uptr))
  (define glfwCreateWindowSurface
    (foreign-procedure "glfwCreateWindowSurface" (uptr uptr uptr uptr) int))

  (define (c-string->string a)
    (let loop ((i 0) (acc '()))
      (let ((b (foreign-ref 'unsigned-8 a i)))
        (if (zero? b)
            (utf8->string (u8-list->bytevector (reverse acc)))
            (loop (+ i 1) (cons b acc))))))

  ;; Raise the most recent GLFW error, with its description.
  (define (glfw-error who)
    (let* ((slot (foreign-alloc (ftype-sizeof uptr)))
           (code (glfwGetError slot))
           (desc (foreign-ref 'uptr slot 0)))
      (foreign-free slot)
      (error who (if (zero? desc) "GLFW error" (c-string->string desc)) code)))

  (define (glfw-init)
    (when (zero? (glfwInit)) (glfw-error 'glfw-init))
    (when (zero? (glfwVulkanSupported))
      (error 'glfw-init "GLFW cannot find a Vulkan loader")))

  (define (glfw-terminate) (glfwTerminate))

  ;; A window without an OpenGL context, for Vulkan.
  (define (glfw-create-window width height title)
    (glfwWindowHint glfw-client-api glfw-no-api)
    (let ((w (glfwCreateWindow width height title 0 0)))
      (when (zero? w) (glfw-error 'glfw-create-window))
      w))

  (define (glfw-destroy-window w) (glfwDestroyWindow w))
  (define (glfw-window-should-close? w) (not (zero? (glfwWindowShouldClose w))))
  (define (glfw-set-window-should-close! w) (glfwSetWindowShouldClose w 1))
  (define (glfw-poll-events) (glfwPollEvents))
  (define (glfw-wait-events) (glfwWaitEvents))
  (define (glfw-time) (glfwGetTime))
  (define (glfw-key-pressed? w key) (= glfw-press (glfwGetKey w key)))

  ;; => (values width height) in pixels
  (define (glfw-framebuffer-size w)
    (let ((p (foreign-alloc 8)))
      (glfwGetFramebufferSize w p (+ p 4))
      (let ((width (foreign-ref 'int p 0)) (height (foreign-ref 'int p 4)))
        (foreign-free p)
        (values width height))))

  ;; Instance extensions GLFW needs for surfaces on this platform.
  (define (glfw-required-instance-extensions)
    (let* ((count-slot (foreign-alloc 4))
           (names (glfwGetRequiredInstanceExtensions count-slot))
           (count (foreign-ref 'unsigned-32 count-slot 0)))
      (foreign-free count-slot)
      (when (zero? names) (glfw-error 'glfw-required-instance-extensions))
      (let loop ((i (- count 1)) (acc '()))
        (if (< i 0)
            acc
            (loop (- i 1)
                  (cons (c-string->string (foreign-ref 'uptr names (* i (ftype-sizeof uptr)))) acc))))))

  ;; => VkSurfaceKHR handle; signals an error with the VkResult on failure.
  (define (glfw-create-window-surface instance window)
    (let* ((slot (foreign-alloc 8))
           (result (glfwCreateWindowSurface instance window 0 slot))
           (surface (foreign-ref 'unsigned-64 slot 0)))
      (foreign-free slot)
      (unless (zero? result)
        (error 'glfw-create-window-surface "Vulkan call failed" result))
      surface))
  )
