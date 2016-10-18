
(library (vulkan wayland)
  (export vk:xlib-surface-create-flags-khr
          vk:xlib-surface-create-info-khr
          vk:create-wayland-surface-khr
          vk:get-physical-device-wayland-presentation-support-khr)
  (import (scheme)
          (vulkan))

  (define-ftype vk:wayland-surface-create-flags-khr vk:flags)
  (define-ftype vk:wayland-surface-create-info-khr
    (struct
     (s-type vk:structure-type)
     (p-next uptr)
     (flags vk:wayland-surface-create-flags-khr)
     (display uptr)
     (surface uptr)))
  
  (define vk:create-wayland-surface-khr
    (foreign-procedure "vkCreateWaylandSurfaceKHR"
                       (vk:instance uptr uptr uptr)
                       vk:result))
  (define vk:get-physical-device-wayland-presentation-support-khr
    (foreign-procedure "vkGetPhysicalDeviceWaylandPresentationSupportKHR"
                       (vk:physical-device unsigned-32 uptr)
                       vk:bool32))
  
  )







