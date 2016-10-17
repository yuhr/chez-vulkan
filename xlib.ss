
(library (vulkan xlib)
  (export vk:xlib-surface-create-flags-khr
          vk:xlib-surface-create-info-khr
          vk:create-xlib-surface-khr
          vk:get-physical-device-xlib-presentation-support-khr)
  (import (scheme)
          (vulkan))

  (define-ftype vk:xlib-surface-create-flags-khr vk:flags)
  (define-ftype vk:xlib-surface-create-info-khr
    (struct
     (s-type vk:structure-type)
     (p-next uptr)
     (flags vk:xlib-surface-create-flags-khr)
     (dpy uptr)
     (window unsigned-64)))
  
  (define vk:create-xlib-surface-khr
    (foreign-procedure "vkCreateXlibSurfaceKHR"
                       (vk:instance uptr uptr uptr)
                       vk:result))
  (define vk:get-physical-device-xlib-presentation-support-khr
    (foreign-procedure "vkGetPhysicalDeviceXlibPresentationSupportKHR"
                       (vk:physical-device uint32-t uptr unsigned-64)
                       vk:bool32))
  
  )
