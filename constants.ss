;;; Vulkan preprocessor constants (#define), which castxml cannot see.
;;; (~0U)-style values are written as negative numbers; Chez accepts them
;;; for unsigned-32/unsigned-64 fields and arguments.
(library (vulkan constants)
  (export vk:make-api-version
          vk:api-version-variant
          vk:api-version-major
          vk:api-version-minor
          vk:api-version-patch
          vk:api-version-1-0
          vk:api-version-1-1
          vk:api-version-1-2
          vk:api-version-1-3
          vk:api-version-1-4
          vk:header-version
          vk:header-version-complete
          vk:lod-clamp-none
          vk:remaining-mip-levels
          vk:remaining-array-layers
          vk:remaining-3d-slices-ext
          vk:whole-size
          vk:attachment-unused
          vk:true
          vk:false
          vk:queue-family-ignored
          vk:queue-family-external
          vk:queue-family-external-khr
          vk:queue-family-foreign-ext
          vk:subpass-external
          vk:shader-unused-khr
          vk:shader-unused-nv
          vk:max-physical-device-name-size
          vk:uuid-size
          vk:luid-size
          vk:luid-size-khr
          vk:max-memory-types
          vk:max-memory-heaps
          vk:max-extension-name-size
          vk:max-description-size
          vk:max-device-group-size
          vk:max-device-group-size-khr
          vk:max-driver-name-size
          vk:max-driver-name-size-khr
          vk:max-driver-info-size
          vk:max-driver-info-size-khr
          vk:max-global-priority-size
          vk:max-global-priority-size-khr
          vk:max-global-priority-size-ext
          vk:max-shader-module-identifier-size-ext
          vk:max-pipeline-binary-key-size-khr)
  (import (scheme))

  (define (vk:make-api-version variant major minor patch)
    (bitwise-ior (bitwise-arithmetic-shift-left variant 29)
                 (bitwise-arithmetic-shift-left major 22)
                 (bitwise-arithmetic-shift-left minor 12)
                 patch))
  (define (vk:api-version-variant v) (bitwise-arithmetic-shift-right v 29))
  (define (vk:api-version-major v) (bitwise-and (bitwise-arithmetic-shift-right v 22) #x7F))
  (define (vk:api-version-minor v) (bitwise-and (bitwise-arithmetic-shift-right v 12) #x3FF))
  (define (vk:api-version-patch v) (bitwise-and v #xFFF))

  (define vk:api-version-1-0 (vk:make-api-version 0 1 0 0))
  (define vk:api-version-1-1 (vk:make-api-version 0 1 1 0))
  (define vk:api-version-1-2 (vk:make-api-version 0 1 2 0))
  (define vk:api-version-1-3 (vk:make-api-version 0 1 3 0))
  (define vk:api-version-1-4 (vk:make-api-version 0 1 4 0))
  ;; Header the bindings were generated from (see res/vulkan.xml).
  (define vk:header-version 363)
  (define vk:header-version-complete (vk:make-api-version 0 1 4 vk:header-version))

  (define vk:lod-clamp-none 1000.0)
  (define vk:remaining-mip-levels -1)
  (define vk:remaining-array-layers -1)
  (define vk:remaining-3d-slices-ext -1)
  (define vk:whole-size -1)
  (define vk:attachment-unused -1)
  (define vk:true 1)
  (define vk:false 0)
  (define vk:queue-family-ignored -1)
  (define vk:queue-family-external -2)
  (define vk:queue-family-external-khr vk:queue-family-external)
  (define vk:queue-family-foreign-ext -3)
  (define vk:subpass-external -1)
  (define vk:shader-unused-khr -1)
  (define vk:shader-unused-nv vk:shader-unused-khr)
  (define vk:max-physical-device-name-size 256)
  (define vk:uuid-size 16)
  (define vk:luid-size 8)
  (define vk:luid-size-khr vk:luid-size)
  (define vk:max-memory-types 32)
  (define vk:max-memory-heaps 16)
  (define vk:max-extension-name-size 256)
  (define vk:max-description-size 256)
  (define vk:max-device-group-size 32)
  (define vk:max-device-group-size-khr vk:max-device-group-size)
  (define vk:max-driver-name-size 256)
  (define vk:max-driver-name-size-khr vk:max-driver-name-size)
  (define vk:max-driver-info-size 256)
  (define vk:max-driver-info-size-khr vk:max-driver-info-size)
  (define vk:max-global-priority-size 16)
  (define vk:max-global-priority-size-khr vk:max-global-priority-size)
  (define vk:max-global-priority-size-ext vk:max-global-priority-size)
  (define vk:max-shader-module-identifier-size-ext 32)
  (define vk:max-pipeline-binary-key-size-khr 32)

  )
