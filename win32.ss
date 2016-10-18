
(library (vulkan xlib)
  (export vk:win32-surface-create-flags-khr
          vk:win32-surface-create-info-khr
          vk:create-win32-surface-khr
          vk:get-physical-device-win32-presentation-support-khr)
  (import (scheme)
          (vulkan))

  (define-ftype vk:win32-surface-create-flags-khr vk:flags)
  (define-ftype vk:win32-surface-create-info-khr
    (struct
     (s-type vk:structure-type)
     (p-next uptr)
     (flags vk:xlib-surface-create-flags-khr)
     (hinstance uptr)
     (hwnd uptr)))
  
  (define vk:create-win32-surface-khr
    (foreign-procedure "vkCreateWin32SurfaceKHR"
                       (vk:instance uptr uptr uptr)
                       vk:result))
  (define vk:get-physical-device-win32-presentation-support-khr
    (foreign-procedure "vkGetPhysicalDeviceWin32PresentationSupportKHR"
                       (vk:physical-device unsigned-32)
                       vk:bool32))
  
  )
