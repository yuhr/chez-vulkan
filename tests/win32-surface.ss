;;; (vulkan win32) test: open a 320x240 Win32 window, create a Vulkan surface
;;; on it and check that the surface has the window's size and that the
;;; device can present to it.  Runs on Windows (or under Wine).
;;;
;;;   scheme --script tests/win32-surface.ss

(load "vulkan.ss")
(load "constants.ss")
(load "win32.ss")
(load "examples/common.ss")
(import (vulkan) (vulkan constants) (vulkan win32) (examples common))

(define (fail . msg) (apply printf msg) (newline) (exit 1))

(load-shared-object "user32.dll")
(load-shared-object "kernel32.dll")
(define-ftype wndclassexw
  (struct (cb-size unsigned-32) (style unsigned-32) (wnd-proc uptr)
          (cls-extra int) (wnd-extra int) (instance uptr) (icon uptr) (cursor uptr)
          (background uptr) (menu-name uptr) (class-name uptr) (icon-small uptr)))
(define GetModuleHandleW (foreign-procedure "GetModuleHandleW" (uptr) uptr))
(define RegisterClassExW (foreign-procedure "RegisterClassExW" (uptr) unsigned-16))
(define CreateWindowExW
  (foreign-procedure "CreateWindowExW"
                     (unsigned-32 wstring wstring unsigned-32 int int int int uptr uptr uptr uptr)
                     uptr))
(define DestroyWindow (foreign-procedure "DestroyWindow" (uptr) int))

(define hinstance (GetModuleHandleW 0))
;; DefWindowProcW as the window procedure, so no Scheme callback is needed.
(define window-class
  (new wndclassexw
       (cb-size (ftype-sizeof wndclassexw))
       (wnd-proc (foreign-entry "DefWindowProcW"))
       (instance hinstance)
       (class-name (bytes->foreign (string->utf16 "chezvulkan\x0;" (endianness little))))))
(when (zero? (RegisterClassExW (addr window-class))) (fail "RegisterClassExW failed"))
(define hwnd
  (CreateWindowExW 0 "chezvulkan" "chez-vulkan test"
                   (bitwise-ior #x80000000 #x10000000) ; WS_POPUP | WS_VISIBLE: no frame
                   0 0 320 240 0 0 hinstance 0))
(when (zero? hwnd) (fail "CreateWindowExW failed"))

(define instance
  (let* ((app (new vk:application-info (s-type vk:structure-type-application-info)
                   (api-version vk:api-version-1-0)))
         (extensions '("VK_KHR_surface" "VK_KHR_win32_surface"))
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
  (let ((info (new vk:win32-surface-create-info-khr
                   (s-type vk:structure-type-win32-surface-create-info-khr)
                   (hinstance hinstance)
                   (hwnd hwnd))))
    (create 'vkCreateWin32SurfaceKHR
            (lambda (out) (vk:create-win32-surface-khr instance (addr info) 0 out)))))

(define caps (new-array vk:surface-capabilities-khr 1))
(check 'vkGetPhysicalDeviceSurfaceCapabilitiesKHR
       (vk:get-physical-device-surface-capabilities-khr physical-device surface (addr caps)))
(define supported (new-array unsigned-32 1))
(check 'vkGetPhysicalDeviceSurfaceSupportKHR
       (vk:get-physical-device-surface-support-khr physical-device 0 surface (addr supported)))
(define surface-support (ftype-ref unsigned-32 () supported))
(define width (ftype-ref vk:surface-capabilities-khr (current-extent width) caps))
(define height (ftype-ref vk:surface-capabilities-khr (current-extent height) caps))
(define presentable (vk:get-physical-device-win32-presentation-support-khr physical-device 0))
(printf "win32 surface: ~ax~a, surface support ~a, presentation support ~a\n"
        width height surface-support presentable)

(vk:destroy-surface-khr instance surface 0)
(vk:destroy-instance instance 0)
(DestroyWindow hwnd)
(free-all)

(unless (and (= width 320) (= height 240)
             (= 1 surface-support)
             (= 1 presentable))
  (fail "FAIL: expected a 320x240 surface the device can present to"))
(printf "ok\n")
