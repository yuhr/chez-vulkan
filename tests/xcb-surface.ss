;;; (vulkan xcb) test: open a 320x240 XCB window, create a Vulkan surface on
;;; it and check that the surface has the window's size and that the device
;;; can present to it.  Needs an X server (e.g. xvfb-run) and libxcb.
;;;
;;;   scheme --script tests/xcb-surface.ss

(load "vulkan.ss")
(load "constants.ss")
(load "xcb.ss")
(load "examples/common.ss")
(import (vulkan) (vulkan constants) (vulkan xcb) (examples common))

(define (fail . msg) (apply printf msg) (newline) (exit 1))

(load-shared-object "libxcb.so.1")
(define-ftype xcb-screen
  (struct (root unsigned-32) (default-colormap unsigned-32) (white-pixel unsigned-32)
          (black-pixel unsigned-32) (current-input-masks unsigned-32)
          (width-in-pixels unsigned-16) (height-in-pixels unsigned-16)
          (width-in-mm unsigned-16) (height-in-mm unsigned-16)
          (min-installed-maps unsigned-16) (max-installed-maps unsigned-16)
          (root-visual unsigned-32)))
(define-ftype xcb-screen-iterator (struct (data uptr) (rem int) (index int)))
(define xcb-connect (foreign-procedure "xcb_connect" (uptr uptr) uptr))
(define xcb-connection-has-error (foreign-procedure "xcb_connection_has_error" (uptr) int))
(define xcb-get-setup (foreign-procedure "xcb_get_setup" (uptr) uptr))
(define xcb-setup-roots-iterator
  (foreign-procedure "xcb_setup_roots_iterator" (uptr) (& xcb-screen-iterator)))
(define xcb-generate-id (foreign-procedure "xcb_generate_id" (uptr) unsigned-32))
(define xcb-create-window
  (foreign-procedure "xcb_create_window"
                     (uptr unsigned-8 unsigned-32 unsigned-32 integer-16 integer-16
                      unsigned-16 unsigned-16 unsigned-16 unsigned-16 unsigned-32
                      unsigned-32 uptr)
                     unsigned-32))
(define xcb-map-window (foreign-procedure "xcb_map_window" (uptr unsigned-32) unsigned-32))
(define xcb-destroy-window (foreign-procedure "xcb_destroy_window" (uptr unsigned-32) unsigned-32))
(define xcb-flush (foreign-procedure "xcb_flush" (uptr) int))
(define xcb-disconnect (foreign-procedure "xcb_disconnect" (uptr) void))

(define conn (xcb-connect 0 0))
(unless (zero? (xcb-connection-has-error conn)) (fail "cannot connect to the X server"))
(define screen
  (let ((it (new-array xcb-screen-iterator 1)))
    (xcb-setup-roots-iterator it (xcb-get-setup conn))
    (make-ftype-pointer xcb-screen (ftype-ref xcb-screen-iterator (data) it))))
(define root-visual (ftype-ref xcb-screen (root-visual) screen))
(define window (xcb-generate-id conn))
(xcb-create-window conn 0 window (ftype-ref xcb-screen (root) screen) 0 0 320 240 0
                   1 root-visual 0 0)            ; XCB_WINDOW_CLASS_INPUT_OUTPUT
(xcb-map-window conn window)
(xcb-flush conn)

(define instance
  (let* ((app (new vk:application-info (s-type vk:structure-type-application-info)
                   (api-version vk:api-version-1-0)))
         (extensions '("VK_KHR_surface" "VK_KHR_xcb_surface"))
         (info (new vk:instance-create-info (s-type vk:structure-type-instance-create-info)
                    (p-application-info (addr app))
                    (enabled-extension-count (length extensions))
                    (pp-enabled-extension-names (c-string-array extensions)))))
    (create 'vkCreateInstance (lambda (out) (vk:create-instance (addr info) 0 out)))))
(define physical-device
  (let-values (((n devices) (enumerate-array uptr (lambda (c p) (vk:enumerate-physical-devices instance c p)))))
    (when (zero? n) (fail "no Vulkan device"))
    (ftype-ref uptr () devices 0)))
(define surface
  (let ((info (new vk:xcb-surface-create-info-khr
                   (s-type vk:structure-type-xcb-surface-create-info-khr)
                   (connection conn)
                   (window window))))
    (create 'vkCreateXcbSurfaceKHR (lambda (out) (vk:create-xcb-surface-khr instance (addr info) 0 out)))))

(define caps (new-array vk:surface-capabilities-khr 1))
(check 'vkGetPhysicalDeviceSurfaceCapabilitiesKHR
       (vk:get-physical-device-surface-capabilities-khr physical-device surface (addr caps)))
(define supported (new-array unsigned-32 1))
(check 'vkGetPhysicalDeviceSurfaceSupportKHR
       (vk:get-physical-device-surface-support-khr physical-device 0 surface (addr supported)))
(define surface-support (ftype-ref unsigned-32 () supported))
(define width (ftype-ref vk:surface-capabilities-khr (current-extent width) caps))
(define height (ftype-ref vk:surface-capabilities-khr (current-extent height) caps))
(define presentable
  (vk:get-physical-device-xcb-presentation-support-khr physical-device 0 conn root-visual))
(printf "xcb surface: ~ax~a, surface support ~a, presentation support ~a\n"
        width height surface-support presentable)

(vk:destroy-surface-khr instance surface 0)
(vk:destroy-instance instance 0)
(xcb-destroy-window conn window)
(xcb-disconnect conn)
(free-all)

(unless (and (= width 320) (= height 240)
             (= 1 surface-support)
             (= 1 presentable))
  (fail "FAIL: expected a 320x240 surface the device can present to"))
(printf "ok\n")
