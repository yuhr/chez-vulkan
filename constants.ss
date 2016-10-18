
(library (vulkan constants)
  (export vk:lod-clamp-none
          vk:remaining-mip-levels
          vk:remaining-array-layers
          vk:whole-size
          vk:attachment-unused
          vk:true
          vk:false
          vk:queue-family-ignored
          vk:subpass-external
          vk:max-physical-device-name-size
          vk:uuid-size
          vk:max-memory-types
          vk:max-memory-heaps
          vk:max-extension-name-size
          vk:max-description-size)
  (import (scheme))
  
  (define vk:lod-clamp-none 1000.0)
  (define vk:remaining-mip-levels -1)
  (define vk:remaining-array-layers -1)
  (define vk:whole-size -1)
  (define vk:attachment-unused -1)
  (define vk:true 1)
  (define vk:false 0)
  (define vk:queue-family-ignored -1)
  (define vk:subpass-external -1)
  (define vk:max-physical-device-name-size 256)
  (define vk:uuid-size 16)
  (define vk:max-memory-types 32)
  (define vk:max-memory-heaps 16)
  (define vk:max-extension-name-size 256)
  (define vk:max-description-size 256)
  
  )
