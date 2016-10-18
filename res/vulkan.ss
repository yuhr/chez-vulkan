(load-shared-object "libvulkan.so")
(library (vulkan)
  (export vk:flags vk:bool32 vk:device-size vk:sample-mask
   vk:instance vk:physical-device vk:device vk:queue
   vk:semaphore vk:command-buffer vk:fence vk:device-memory
   vk:buffer vk:image vk:event vk:query-pool vk:buffer-view
   vk:image-view vk:shader-module vk:pipeline-cache
   vk:pipeline-layout vk:render-pass vk:pipeline
   vk:descriptor-set-layout vk:sampler vk:descriptor-pool
   vk:descriptor-set vk:framebuffer vk:command-pool
   vk:pipeline-cache-header-version
   vk:pipeline-cache-header-version-one
   vk:pipeline-cache-header-version-begin-range
   vk:pipeline-cache-header-version-end-range
   vk:pipeline-cache-header-version-range-size
   vk:pipeline-cache-header-version-max-enum vk:result
   vk:success vk:not-ready vk:timeout vk:event-set
   vk:event-reset vk:incomplete vk:error-out-of-host-memory
   vk:error-out-of-device-memory vk:error-initialization-failed
   vk:error-device-lost vk:error-memory-map-failed
   vk:error-layer-not-present vk:error-extension-not-present
   vk:error-feature-not-present vk:error-incompatible-driver
   vk:error-too-many-objects vk:error-format-not-supported
   vk:error-fragmented-pool vk:error-surface-lost-khr
   vk:error-native-window-in-use-khr vk:suboptimal-khr
   vk:error-out-of-date-khr vk:error-incompatible-display-khr
   vk:error-validation-failed-ext vk:error-invalid-shader-nv
   vk:result-begin-range vk:result-end-range
   vk:result-range-size vk:result-max-enum vk:structure-type
   vk:structure-type-application-info
   vk:structure-type-instance-create-info
   vk:structure-type-device-queue-create-info
   vk:structure-type-device-create-info
   vk:structure-type-submit-info
   vk:structure-type-memory-allocate-info
   vk:structure-type-mapped-memory-range
   vk:structure-type-bind-sparse-info
   vk:structure-type-fence-create-info
   vk:structure-type-semaphore-create-info
   vk:structure-type-event-create-info
   vk:structure-type-query-pool-create-info
   vk:structure-type-buffer-create-info
   vk:structure-type-buffer-view-create-info
   vk:structure-type-image-create-info
   vk:structure-type-image-view-create-info
   vk:structure-type-shader-module-create-info
   vk:structure-type-pipeline-cache-create-info
   vk:structure-type-pipeline-shader-stage-create-info
   vk:structure-type-pipeline-vertex-input-state-create-info
   vk:structure-type-pipeline-input-assembly-state-create-info
   vk:structure-type-pipeline-tessellation-state-create-info
   vk:structure-type-pipeline-viewport-state-create-info
   vk:structure-type-pipeline-rasterization-state-create-info
   vk:structure-type-pipeline-multisample-state-create-info
   vk:structure-type-pipeline-depth-stencil-state-create-info
   vk:structure-type-pipeline-color-blend-state-create-info
   vk:structure-type-pipeline-dynamic-state-create-info
   vk:structure-type-graphics-pipeline-create-info
   vk:structure-type-compute-pipeline-create-info
   vk:structure-type-pipeline-layout-create-info
   vk:structure-type-sampler-create-info
   vk:structure-type-descriptor-set-layout-create-info
   vk:structure-type-descriptor-pool-create-info
   vk:structure-type-descriptor-set-allocate-info
   vk:structure-type-write-descriptor-set
   vk:structure-type-copy-descriptor-set
   vk:structure-type-framebuffer-create-info
   vk:structure-type-render-pass-create-info
   vk:structure-type-command-pool-create-info
   vk:structure-type-command-buffer-allocate-info
   vk:structure-type-command-buffer-inheritance-info
   vk:structure-type-command-buffer-begin-info
   vk:structure-type-render-pass-begin-info
   vk:structure-type-buffer-memory-barrier
   vk:structure-type-image-memory-barrier
   vk:structure-type-memory-barrier
   vk:structure-type-loader-instance-create-info
   vk:structure-type-loader-device-create-info
   vk:structure-type-swapchain-create-info-khr
   vk:structure-type-present-info-khr
   vk:structure-type-display-mode-create-info-khr
   vk:structure-type-display-surface-create-info-khr
   vk:structure-type-display-present-info-khr
   vk:structure-type-xlib-surface-create-info-khr
   vk:structure-type-xcb-surface-create-info-khr
   vk:structure-type-wayland-surface-create-info-khr
   vk:structure-type-mir-surface-create-info-khr
   vk:structure-type-android-surface-create-info-khr
   vk:structure-type-win32-surface-create-info-khr
   vk:structure-type-debug-report-callback-create-info-ext
   vk:structure-type-pipeline-rasterization-state-rasterization-order-amd
   vk:structure-type-debug-marker-object-name-info-ext
   vk:structure-type-debug-marker-object-tag-info-ext
   vk:structure-type-debug-marker-marker-info-ext
   vk:structure-type-dedicated-allocation-image-create-info-nv
   vk:structure-type-dedicated-allocation-buffer-create-info-nv
   vk:structure-type-dedicated-allocation-memory-allocate-info-nv
   vk:structure-type-external-memory-image-create-info-nv
   vk:structure-type-export-memory-allocate-info-nv
   vk:structure-type-import-memory-win32-handle-info-nv
   vk:structure-type-export-memory-win32-handle-info-nv
   vk:structure-type-win32-keyed-mutex-acquire-release-info-nv
   vk:structure-type-validation-flags-ext
   vk:structure-type-begin-range vk:structure-type-end-range
   vk:structure-type-range-size vk:structure-type-max-enum
   vk:system-allocation-scope
   vk:system-allocation-scope-command
   vk:system-allocation-scope-object
   vk:system-allocation-scope-cache
   vk:system-allocation-scope-device
   vk:system-allocation-scope-instance
   vk:system-allocation-scope-begin-range
   vk:system-allocation-scope-end-range
   vk:system-allocation-scope-range-size
   vk:system-allocation-scope-max-enum
   vk:internal-allocation-type
   vk:internal-allocation-type-executable
   vk:internal-allocation-type-begin-range
   vk:internal-allocation-type-end-range
   vk:internal-allocation-type-range-size
   vk:internal-allocation-type-max-enum vk:format
   vk:format-undefined vk:format-r4g4-unorm-pack8
   vk:format-r4g4b4a4-unorm-pack16
   vk:format-b4g4r4a4-unorm-pack16
   vk:format-r5g6b5-unorm-pack16 vk:format-b5g6r5-unorm-pack16
   vk:format-r5g5b5a1-unorm-pack16
   vk:format-b5g5r5a1-unorm-pack16
   vk:format-a1r5g5b5-unorm-pack16 vk:format-r8-unorm
   vk:format-r8-snorm vk:format-r8-uscaled vk:format-r8-sscaled
   vk:format-r8-uint vk:format-r8-sint vk:format-r8-srgb
   vk:format-r8g8-unorm vk:format-r8g8-snorm
   vk:format-r8g8-uscaled vk:format-r8g8-sscaled
   vk:format-r8g8-uint vk:format-r8g8-sint vk:format-r8g8-srgb
   vk:format-r8g8b8-unorm vk:format-r8g8b8-snorm
   vk:format-r8g8b8-uscaled vk:format-r8g8b8-sscaled
   vk:format-r8g8b8-uint vk:format-r8g8b8-sint
   vk:format-r8g8b8-srgb vk:format-b8g8r8-unorm
   vk:format-b8g8r8-snorm vk:format-b8g8r8-uscaled
   vk:format-b8g8r8-sscaled vk:format-b8g8r8-uint
   vk:format-b8g8r8-sint vk:format-b8g8r8-srgb
   vk:format-r8g8b8a8-unorm vk:format-r8g8b8a8-snorm
   vk:format-r8g8b8a8-uscaled vk:format-r8g8b8a8-sscaled
   vk:format-r8g8b8a8-uint vk:format-r8g8b8a8-sint
   vk:format-r8g8b8a8-srgb vk:format-b8g8r8a8-unorm
   vk:format-b8g8r8a8-snorm vk:format-b8g8r8a8-uscaled
   vk:format-b8g8r8a8-sscaled vk:format-b8g8r8a8-uint
   vk:format-b8g8r8a8-sint vk:format-b8g8r8a8-srgb
   vk:format-a8b8g8r8-unorm-pack32
   vk:format-a8b8g8r8-snorm-pack32
   vk:format-a8b8g8r8-uscaled-pack32
   vk:format-a8b8g8r8-sscaled-pack32
   vk:format-a8b8g8r8-uint-pack32
   vk:format-a8b8g8r8-sint-pack32
   vk:format-a8b8g8r8-srgb-pack32
   vk:format-a2r10g10b10-unorm-pack32
   vk:format-a2r10g10b10-snorm-pack32
   vk:format-a2r10g10b10-uscaled-pack32
   vk:format-a2r10g10b10-sscaled-pack32
   vk:format-a2r10g10b10-uint-pack32
   vk:format-a2r10g10b10-sint-pack32
   vk:format-a2b10g10r10-unorm-pack32
   vk:format-a2b10g10r10-snorm-pack32
   vk:format-a2b10g10r10-uscaled-pack32
   vk:format-a2b10g10r10-sscaled-pack32
   vk:format-a2b10g10r10-uint-pack32
   vk:format-a2b10g10r10-sint-pack32 vk:format-r16-unorm
   vk:format-r16-snorm vk:format-r16-uscaled
   vk:format-r16-sscaled vk:format-r16-uint vk:format-r16-sint
   vk:format-r16-sfloat vk:format-r16g16-unorm
   vk:format-r16g16-snorm vk:format-r16g16-uscaled
   vk:format-r16g16-sscaled vk:format-r16g16-uint
   vk:format-r16g16-sint vk:format-r16g16-sfloat
   vk:format-r16g16b16-unorm vk:format-r16g16b16-snorm
   vk:format-r16g16b16-uscaled vk:format-r16g16b16-sscaled
   vk:format-r16g16b16-uint vk:format-r16g16b16-sint
   vk:format-r16g16b16-sfloat vk:format-r16g16b16a16-unorm
   vk:format-r16g16b16a16-snorm vk:format-r16g16b16a16-uscaled
   vk:format-r16g16b16a16-sscaled vk:format-r16g16b16a16-uint
   vk:format-r16g16b16a16-sint vk:format-r16g16b16a16-sfloat
   vk:format-r32-uint vk:format-r32-sint vk:format-r32-sfloat
   vk:format-r32g32-uint vk:format-r32g32-sint
   vk:format-r32g32-sfloat vk:format-r32g32b32-uint
   vk:format-r32g32b32-sint vk:format-r32g32b32-sfloat
   vk:format-r32g32b32a32-uint vk:format-r32g32b32a32-sint
   vk:format-r32g32b32a32-sfloat vk:format-r64-uint
   vk:format-r64-sint vk:format-r64-sfloat
   vk:format-r64g64-uint vk:format-r64g64-sint
   vk:format-r64g64-sfloat vk:format-r64g64b64-uint
   vk:format-r64g64b64-sint vk:format-r64g64b64-sfloat
   vk:format-r64g64b64a64-uint vk:format-r64g64b64a64-sint
   vk:format-r64g64b64a64-sfloat
   vk:format-b10g11r11-ufloat-pack32
   vk:format-e5b9g9r9-ufloat-pack32 vk:format-d16-unorm
   vk:format-x8-d24-unorm-pack32 vk:format-d32-sfloat
   vk:format-s8-uint vk:format-d16-unorm-s8-uint
   vk:format-d24-unorm-s8-uint vk:format-d32-sfloat-s8-uint
   vk:format-bc1-rgb-unorm-block vk:format-bc1-rgb-srgb-block
   vk:format-bc1-rgba-unorm-block vk:format-bc1-rgba-srgb-block
   vk:format-bc2-unorm-block vk:format-bc2-srgb-block
   vk:format-bc3-unorm-block vk:format-bc3-srgb-block
   vk:format-bc4-unorm-block vk:format-bc4-snorm-block
   vk:format-bc5-unorm-block vk:format-bc5-snorm-block
   vk:format-bc6h-ufloat-block vk:format-bc6h-sfloat-block
   vk:format-bc7-unorm-block vk:format-bc7-srgb-block
   vk:format-etc2-r8g8b8-unorm-block
   vk:format-etc2-r8g8b8-srgb-block
   vk:format-etc2-r8g8b8a1-unorm-block
   vk:format-etc2-r8g8b8a1-srgb-block
   vk:format-etc2-r8g8b8a8-unorm-block
   vk:format-etc2-r8g8b8a8-srgb-block
   vk:format-eac-r11-unorm-block vk:format-eac-r11-snorm-block
   vk:format-eac-r11g11-unorm-block
   vk:format-eac-r11g11-snorm-block
   vk:format-astc-4x4-unorm-block vk:format-astc-4x4-srgb-block
   vk:format-astc-5x4-unorm-block vk:format-astc-5x4-srgb-block
   vk:format-astc-5x5-unorm-block vk:format-astc-5x5-srgb-block
   vk:format-astc-6x5-unorm-block vk:format-astc-6x5-srgb-block
   vk:format-astc-6x6-unorm-block vk:format-astc-6x6-srgb-block
   vk:format-astc-8x5-unorm-block vk:format-astc-8x5-srgb-block
   vk:format-astc-8x6-unorm-block vk:format-astc-8x6-srgb-block
   vk:format-astc-8x8-unorm-block vk:format-astc-8x8-srgb-block
   vk:format-astc-10x5-unorm-block
   vk:format-astc-10x5-srgb-block
   vk:format-astc-10x6-unorm-block
   vk:format-astc-10x6-srgb-block
   vk:format-astc-10x8-unorm-block
   vk:format-astc-10x8-srgb-block
   vk:format-astc-10x10-unorm-block
   vk:format-astc-10x10-srgb-block
   vk:format-astc-12x10-unorm-block
   vk:format-astc-12x10-srgb-block
   vk:format-astc-12x12-unorm-block
   vk:format-astc-12x12-srgb-block
   vk:format-pvrtc1-2bpp-unorm-block-img
   vk:format-pvrtc1-4bpp-unorm-block-img
   vk:format-pvrtc2-2bpp-unorm-block-img
   vk:format-pvrtc2-4bpp-unorm-block-img
   vk:format-pvrtc1-2bpp-srgb-block-img
   vk:format-pvrtc1-4bpp-srgb-block-img
   vk:format-pvrtc2-2bpp-srgb-block-img
   vk:format-pvrtc2-4bpp-srgb-block-img vk:format-begin-range
   vk:format-end-range vk:format-range-size vk:format-max-enum
   vk:image-type vk:image-type-1d vk:image-type-2d
   vk:image-type-3d vk:image-type-begin-range
   vk:image-type-end-range vk:image-type-range-size
   vk:image-type-max-enum vk:image-tiling
   vk:image-tiling-optimal vk:image-tiling-linear
   vk:image-tiling-begin-range vk:image-tiling-end-range
   vk:image-tiling-range-size vk:image-tiling-max-enum
   vk:physical-device-type vk:physical-device-type-other
   vk:physical-device-type-integrated-gpu
   vk:physical-device-type-discrete-gpu
   vk:physical-device-type-virtual-gpu
   vk:physical-device-type-cpu
   vk:physical-device-type-begin-range
   vk:physical-device-type-end-range
   vk:physical-device-type-range-size
   vk:physical-device-type-max-enum vk:query-type
   vk:query-type-occlusion vk:query-type-pipeline-statistics
   vk:query-type-timestamp vk:query-type-begin-range
   vk:query-type-end-range vk:query-type-range-size
   vk:query-type-max-enum vk:sharing-mode
   vk:sharing-mode-exclusive vk:sharing-mode-concurrent
   vk:sharing-mode-begin-range vk:sharing-mode-end-range
   vk:sharing-mode-range-size vk:sharing-mode-max-enum
   vk:image-layout vk:image-layout-undefined
   vk:image-layout-general
   vk:image-layout-color-attachment-optimal
   vk:image-layout-depth-stencil-attachment-optimal
   vk:image-layout-depth-stencil-read-only-optimal
   vk:image-layout-shader-read-only-optimal
   vk:image-layout-transfer-src-optimal
   vk:image-layout-transfer-dst-optimal
   vk:image-layout-preinitialized
   vk:image-layout-present-src-khr vk:image-layout-begin-range
   vk:image-layout-end-range vk:image-layout-range-size
   vk:image-layout-max-enum vk:image-view-type
   vk:image-view-type-1d vk:image-view-type-2d
   vk:image-view-type-3d vk:image-view-type-cube
   vk:image-view-type-1d-array vk:image-view-type-2d-array
   vk:image-view-type-cube-array vk:image-view-type-begin-range
   vk:image-view-type-end-range vk:image-view-type-range-size
   vk:image-view-type-max-enum vk:component-swizzle
   vk:component-swizzle-identity vk:component-swizzle-zero
   vk:component-swizzle-one vk:component-swizzle-r
   vk:component-swizzle-g vk:component-swizzle-b
   vk:component-swizzle-a vk:component-swizzle-begin-range
   vk:component-swizzle-end-range
   vk:component-swizzle-range-size
   vk:component-swizzle-max-enum vk:vertex-input-rate
   vk:vertex-input-rate-vertex vk:vertex-input-rate-instance
   vk:vertex-input-rate-begin-range
   vk:vertex-input-rate-end-range
   vk:vertex-input-rate-range-size
   vk:vertex-input-rate-max-enum vk:primitive-topology
   vk:primitive-topology-point-list
   vk:primitive-topology-line-list
   vk:primitive-topology-line-strip
   vk:primitive-topology-triangle-list
   vk:primitive-topology-triangle-strip
   vk:primitive-topology-triangle-fan
   vk:primitive-topology-line-list-with-adjacency
   vk:primitive-topology-line-strip-with-adjacency
   vk:primitive-topology-triangle-list-with-adjacency
   vk:primitive-topology-triangle-strip-with-adjacency
   vk:primitive-topology-patch-list
   vk:primitive-topology-begin-range
   vk:primitive-topology-end-range
   vk:primitive-topology-range-size
   vk:primitive-topology-max-enum vk:polygon-mode
   vk:polygon-mode-fill vk:polygon-mode-line
   vk:polygon-mode-point vk:polygon-mode-begin-range
   vk:polygon-mode-end-range vk:polygon-mode-range-size
   vk:polygon-mode-max-enum vk:front-face
   vk:front-face-counter-clockwise vk:front-face-clockwise
   vk:front-face-begin-range vk:front-face-end-range
   vk:front-face-range-size vk:front-face-max-enum
   vk:compare-op vk:compare-op-never vk:compare-op-less
   vk:compare-op-equal vk:compare-op-less-or-equal
   vk:compare-op-greater vk:compare-op-not-equal
   vk:compare-op-greater-or-equal vk:compare-op-always
   vk:compare-op-begin-range vk:compare-op-end-range
   vk:compare-op-range-size vk:compare-op-max-enum
   vk:stencil-op vk:stencil-op-keep vk:stencil-op-zero
   vk:stencil-op-replace vk:stencil-op-increment-and-clamp
   vk:stencil-op-decrement-and-clamp vk:stencil-op-invert
   vk:stencil-op-increment-and-wrap
   vk:stencil-op-decrement-and-wrap vk:stencil-op-begin-range
   vk:stencil-op-end-range vk:stencil-op-range-size
   vk:stencil-op-max-enum vk:logic-op vk:logic-op-clear
   vk:logic-op-and vk:logic-op-and-reverse vk:logic-op-copy
   vk:logic-op-and-inverted vk:logic-op-no-op vk:logic-op-xor
   vk:logic-op-or vk:logic-op-nor vk:logic-op-equivalent
   vk:logic-op-invert vk:logic-op-or-reverse
   vk:logic-op-copy-inverted vk:logic-op-or-inverted
   vk:logic-op-nand vk:logic-op-set vk:logic-op-begin-range
   vk:logic-op-end-range vk:logic-op-range-size
   vk:logic-op-max-enum vk:blend-factor vk:blend-factor-zero
   vk:blend-factor-one vk:blend-factor-src-color
   vk:blend-factor-one-minus-src-color
   vk:blend-factor-dst-color
   vk:blend-factor-one-minus-dst-color
   vk:blend-factor-src-alpha
   vk:blend-factor-one-minus-src-alpha
   vk:blend-factor-dst-alpha
   vk:blend-factor-one-minus-dst-alpha
   vk:blend-factor-constant-color
   vk:blend-factor-one-minus-constant-color
   vk:blend-factor-constant-alpha
   vk:blend-factor-one-minus-constant-alpha
   vk:blend-factor-src-alpha-saturate
   vk:blend-factor-src1-color
   vk:blend-factor-one-minus-src1-color
   vk:blend-factor-src1-alpha
   vk:blend-factor-one-minus-src1-alpha
   vk:blend-factor-begin-range vk:blend-factor-end-range
   vk:blend-factor-range-size vk:blend-factor-max-enum
   vk:blend-op vk:blend-op-add vk:blend-op-subtract
   vk:blend-op-reverse-subtract vk:blend-op-min vk:blend-op-max
   vk:blend-op-begin-range vk:blend-op-end-range
   vk:blend-op-range-size vk:blend-op-max-enum vk:dynamic-state
   vk:dynamic-state-viewport vk:dynamic-state-scissor
   vk:dynamic-state-line-width vk:dynamic-state-depth-bias
   vk:dynamic-state-blend-constants
   vk:dynamic-state-depth-bounds
   vk:dynamic-state-stencil-compare-mask
   vk:dynamic-state-stencil-write-mask
   vk:dynamic-state-stencil-reference
   vk:dynamic-state-begin-range vk:dynamic-state-end-range
   vk:dynamic-state-range-size vk:dynamic-state-max-enum
   vk:filter vk:filter-nearest vk:filter-linear
   vk:filter-cubic-img vk:filter-begin-range
   vk:filter-end-range vk:filter-range-size vk:filter-max-enum
   vk:sampler-mipmap-mode vk:sampler-mipmap-mode-nearest
   vk:sampler-mipmap-mode-linear
   vk:sampler-mipmap-mode-begin-range
   vk:sampler-mipmap-mode-end-range
   vk:sampler-mipmap-mode-range-size
   vk:sampler-mipmap-mode-max-enum vk:sampler-address-mode
   vk:sampler-address-mode-repeat
   vk:sampler-address-mode-mirrored-repeat
   vk:sampler-address-mode-clamp-to-edge
   vk:sampler-address-mode-clamp-to-border
   vk:sampler-address-mode-mirror-clamp-to-edge
   vk:sampler-address-mode-begin-range
   vk:sampler-address-mode-end-range
   vk:sampler-address-mode-range-size
   vk:sampler-address-mode-max-enum vk:border-color
   vk:border-color-float-transparent-black
   vk:border-color-int-transparent-black
   vk:border-color-float-opaque-black
   vk:border-color-int-opaque-black
   vk:border-color-float-opaque-white
   vk:border-color-int-opaque-white vk:border-color-begin-range
   vk:border-color-end-range vk:border-color-range-size
   vk:border-color-max-enum vk:descriptor-type
   vk:descriptor-type-sampler
   vk:descriptor-type-combined-image-sampler
   vk:descriptor-type-sampled-image
   vk:descriptor-type-storage-image
   vk:descriptor-type-uniform-texel-buffer
   vk:descriptor-type-storage-texel-buffer
   vk:descriptor-type-uniform-buffer
   vk:descriptor-type-storage-buffer
   vk:descriptor-type-uniform-buffer-dynamic
   vk:descriptor-type-storage-buffer-dynamic
   vk:descriptor-type-input-attachment
   vk:descriptor-type-begin-range vk:descriptor-type-end-range
   vk:descriptor-type-range-size vk:descriptor-type-max-enum
   vk:attachment-load-op vk:attachment-load-op-load
   vk:attachment-load-op-clear vk:attachment-load-op-dont-care
   vk:attachment-load-op-begin-range
   vk:attachment-load-op-end-range
   vk:attachment-load-op-range-size
   vk:attachment-load-op-max-enum vk:attachment-store-op
   vk:attachment-store-op-store
   vk:attachment-store-op-dont-care
   vk:attachment-store-op-begin-range
   vk:attachment-store-op-end-range
   vk:attachment-store-op-range-size
   vk:attachment-store-op-max-enum vk:pipeline-bind-point
   vk:pipeline-bind-point-graphics
   vk:pipeline-bind-point-compute
   vk:pipeline-bind-point-begin-range
   vk:pipeline-bind-point-end-range
   vk:pipeline-bind-point-range-size
   vk:pipeline-bind-point-max-enum vk:command-buffer-level
   vk:command-buffer-level-primary
   vk:command-buffer-level-secondary
   vk:command-buffer-level-begin-range
   vk:command-buffer-level-end-range
   vk:command-buffer-level-range-size
   vk:command-buffer-level-max-enum vk:index-type
   vk:index-type-uint16 vk:index-type-uint32
   vk:index-type-begin-range vk:index-type-end-range
   vk:index-type-range-size vk:index-type-max-enum
   vk:subpass-contents vk:subpass-contents-inline
   vk:subpass-contents-secondary-command-buffers
   vk:subpass-contents-begin-range
   vk:subpass-contents-end-range vk:subpass-contents-range-size
   vk:subpass-contents-max-enum vk:instance-create-flags
   vk:format-feature-flag-bits
   vk:format-feature-sampled-image-bit
   vk:format-feature-storage-image-bit
   vk:format-feature-storage-image-atomic-bit
   vk:format-feature-uniform-texel-buffer-bit
   vk:format-feature-storage-texel-buffer-bit
   vk:format-feature-storage-texel-buffer-atomic-bit
   vk:format-feature-vertex-buffer-bit
   vk:format-feature-color-attachment-bit
   vk:format-feature-color-attachment-blend-bit
   vk:format-feature-depth-stencil-attachment-bit
   vk:format-feature-blit-src-bit
   vk:format-feature-blit-dst-bit
   vk:format-feature-sampled-image-filter-linear-bit
   vk:format-feature-sampled-image-filter-cubic-bit-img
   vk:format-feature-flag-bits-max-enum vk:format-feature-flags
   vk:image-usage-flag-bits vk:image-usage-transfer-src-bit
   vk:image-usage-transfer-dst-bit vk:image-usage-sampled-bit
   vk:image-usage-storage-bit
   vk:image-usage-color-attachment-bit
   vk:image-usage-depth-stencil-attachment-bit
   vk:image-usage-transient-attachment-bit
   vk:image-usage-input-attachment-bit
   vk:image-usage-flag-bits-max-enum vk:image-usage-flags
   vk:image-create-flag-bits vk:image-create-sparse-binding-bit
   vk:image-create-sparse-residency-bit
   vk:image-create-sparse-aliased-bit
   vk:image-create-mutable-format-bit
   vk:image-create-cube-compatible-bit
   vk:image-create-flag-bits-max-enum vk:image-create-flags
   vk:sample-count-flag-bits vk:sample-count-1-bit
   vk:sample-count-2-bit vk:sample-count-4-bit
   vk:sample-count-8-bit vk:sample-count-16-bit
   vk:sample-count-32-bit vk:sample-count-64-bit
   vk:sample-count-flag-bits-max-enum vk:sample-count-flags
   vk:queue-flag-bits vk:queue-graphics-bit
   vk:queue-compute-bit vk:queue-transfer-bit
   vk:queue-sparse-binding-bit vk:queue-flag-bits-max-enum
   vk:queue-flags vk:memory-property-flag-bits
   vk:memory-property-device-local-bit
   vk:memory-property-host-visible-bit
   vk:memory-property-host-coherent-bit
   vk:memory-property-host-cached-bit
   vk:memory-property-lazily-allocated-bit
   vk:memory-property-flag-bits-max-enum
   vk:memory-property-flags vk:memory-heap-flag-bits
   vk:memory-heap-device-local-bit
   vk:memory-heap-flag-bits-max-enum vk:memory-heap-flags
   vk:device-create-flags vk:device-queue-create-flags
   vk:pipeline-stage-flag-bits
   vk:pipeline-stage-top-of-pipe-bit
   vk:pipeline-stage-draw-indirect-bit
   vk:pipeline-stage-vertex-input-bit
   vk:pipeline-stage-vertex-shader-bit
   vk:pipeline-stage-tessellation-control-shader-bit
   vk:pipeline-stage-tessellation-evaluation-shader-bit
   vk:pipeline-stage-geometry-shader-bit
   vk:pipeline-stage-fragment-shader-bit
   vk:pipeline-stage-early-fragment-tests-bit
   vk:pipeline-stage-late-fragment-tests-bit
   vk:pipeline-stage-color-attachment-output-bit
   vk:pipeline-stage-compute-shader-bit
   vk:pipeline-stage-transfer-bit
   vk:pipeline-stage-bottom-of-pipe-bit
   vk:pipeline-stage-host-bit
   vk:pipeline-stage-all-graphics-bit
   vk:pipeline-stage-all-commands-bit
   vk:pipeline-stage-flag-bits-max-enum vk:pipeline-stage-flags
   vk:memory-map-flags vk:image-aspect-flag-bits
   vk:image-aspect-color-bit vk:image-aspect-depth-bit
   vk:image-aspect-stencil-bit vk:image-aspect-metadata-bit
   vk:image-aspect-flag-bits-max-enum vk:image-aspect-flags
   vk:sparse-image-format-flag-bits
   vk:sparse-image-format-single-miptail-bit
   vk:sparse-image-format-aligned-mip-size-bit
   vk:sparse-image-format-nonstandard-block-size-bit
   vk:sparse-image-format-flag-bits-max-enum
   vk:sparse-image-format-flags vk:sparse-memory-bind-flag-bits
   vk:sparse-memory-bind-metadata-bit
   vk:sparse-memory-bind-flag-bits-max-enum
   vk:sparse-memory-bind-flags vk:fence-create-flag-bits
   vk:fence-create-signaled-bit
   vk:fence-create-flag-bits-max-enum vk:fence-create-flags
   vk:semaphore-create-flags vk:event-create-flags
   vk:query-pool-create-flags
   vk:query-pipeline-statistic-flag-bits
   vk:query-pipeline-statistic-input-assembly-vertices-bit
   vk:query-pipeline-statistic-input-assembly-primitives-bit
   vk:query-pipeline-statistic-vertex-shader-invocations-bit
   vk:query-pipeline-statistic-geometry-shader-invocations-bit
   vk:query-pipeline-statistic-geometry-shader-primitives-bit
   vk:query-pipeline-statistic-clipping-invocations-bit
   vk:query-pipeline-statistic-clipping-primitives-bit
   vk:query-pipeline-statistic-fragment-shader-invocations-bit
   vk:query-pipeline-statistic-tessellation-control-shader-patches-bit
   vk:query-pipeline-statistic-tessellation-evaluation-shader-invocations-bit
   vk:query-pipeline-statistic-compute-shader-invocations-bit
   vk:query-pipeline-statistic-flag-bits-max-enum
   vk:query-pipeline-statistic-flags vk:query-result-flag-bits
   vk:query-result-64-bit vk:query-result-wait-bit
   vk:query-result-with-availability-bit
   vk:query-result-partial-bit
   vk:query-result-flag-bits-max-enum vk:query-result-flags
   vk:buffer-create-flag-bits
   vk:buffer-create-sparse-binding-bit
   vk:buffer-create-sparse-residency-bit
   vk:buffer-create-sparse-aliased-bit
   vk:buffer-create-flag-bits-max-enum vk:buffer-create-flags
   vk:buffer-usage-flag-bits vk:buffer-usage-transfer-src-bit
   vk:buffer-usage-transfer-dst-bit
   vk:buffer-usage-uniform-texel-buffer-bit
   vk:buffer-usage-storage-texel-buffer-bit
   vk:buffer-usage-uniform-buffer-bit
   vk:buffer-usage-storage-buffer-bit
   vk:buffer-usage-index-buffer-bit
   vk:buffer-usage-vertex-buffer-bit
   vk:buffer-usage-indirect-buffer-bit
   vk:buffer-usage-flag-bits-max-enum vk:buffer-usage-flags
   vk:buffer-view-create-flags vk:image-view-create-flags
   vk:shader-module-create-flags vk:pipeline-cache-create-flags
   vk:pipeline-create-flag-bits
   vk:pipeline-create-disable-optimization-bit
   vk:pipeline-create-allow-derivatives-bit
   vk:pipeline-create-derivative-bit
   vk:pipeline-create-flag-bits-max-enum
   vk:pipeline-create-flags
   vk:pipeline-shader-stage-create-flags
   vk:shader-stage-flag-bits vk:shader-stage-vertex-bit
   vk:shader-stage-tessellation-control-bit
   vk:shader-stage-tessellation-evaluation-bit
   vk:shader-stage-geometry-bit vk:shader-stage-fragment-bit
   vk:shader-stage-compute-bit vk:shader-stage-all-graphics
   vk:shader-stage-all vk:shader-stage-flag-bits-max-enum
   vk:pipeline-vertex-input-state-create-flags
   vk:pipeline-input-assembly-state-create-flags
   vk:pipeline-tessellation-state-create-flags
   vk:pipeline-viewport-state-create-flags
   vk:pipeline-rasterization-state-create-flags
   vk:cull-mode-flag-bits vk:cull-mode-none
   vk:cull-mode-front-bit vk:cull-mode-back-bit
   vk:cull-mode-front-and-back vk:cull-mode-flag-bits-max-enum
   vk:cull-mode-flags
   vk:pipeline-multisample-state-create-flags
   vk:pipeline-depth-stencil-state-create-flags
   vk:pipeline-color-blend-state-create-flags
   vk:color-component-flag-bits vk:color-component-r-bit
   vk:color-component-g-bit vk:color-component-b-bit
   vk:color-component-a-bit
   vk:color-component-flag-bits-max-enum
   vk:color-component-flags
   vk:pipeline-dynamic-state-create-flags
   vk:pipeline-layout-create-flags vk:shader-stage-flags
   vk:sampler-create-flags
   vk:descriptor-set-layout-create-flags
   vk:descriptor-pool-create-flag-bits
   vk:descriptor-pool-create-free-descriptor-set-bit
   vk:descriptor-pool-create-flag-bits-max-enum
   vk:descriptor-pool-create-flags
   vk:descriptor-pool-reset-flags vk:framebuffer-create-flags
   vk:render-pass-create-flags
   vk:attachment-description-flag-bits
   vk:attachment-description-may-alias-bit
   vk:attachment-description-flag-bits-max-enum
   vk:attachment-description-flags vk:subpass-description-flags
   vk:access-flag-bits vk:access-indirect-command-read-bit
   vk:access-index-read-bit vk:access-vertex-attribute-read-bit
   vk:access-uniform-read-bit
   vk:access-input-attachment-read-bit
   vk:access-shader-read-bit vk:access-shader-write-bit
   vk:access-color-attachment-read-bit
   vk:access-color-attachment-write-bit
   vk:access-depth-stencil-attachment-read-bit
   vk:access-depth-stencil-attachment-write-bit
   vk:access-transfer-read-bit vk:access-transfer-write-bit
   vk:access-host-read-bit vk:access-host-write-bit
   vk:access-memory-read-bit vk:access-memory-write-bit
   vk:access-flag-bits-max-enum vk:access-flags
   vk:dependency-flag-bits vk:dependency-by-region-bit
   vk:dependency-flag-bits-max-enum vk:dependency-flags
   vk:command-pool-create-flag-bits
   vk:command-pool-create-transient-bit
   vk:command-pool-create-reset-command-buffer-bit
   vk:command-pool-create-flag-bits-max-enum
   vk:command-pool-create-flags vk:command-pool-reset-flag-bits
   vk:command-pool-reset-release-resources-bit
   vk:command-pool-reset-flag-bits-max-enum
   vk:command-pool-reset-flags
   vk:command-buffer-usage-flag-bits
   vk:command-buffer-usage-one-time-submit-bit
   vk:command-buffer-usage-render-pass-continue-bit
   vk:command-buffer-usage-simultaneous-use-bit
   vk:command-buffer-usage-flag-bits-max-enum
   vk:command-buffer-usage-flags vk:query-control-flag-bits
   vk:query-control-precise-bit
   vk:query-control-flag-bits-max-enum vk:query-control-flags
   vk:command-buffer-reset-flag-bits
   vk:command-buffer-reset-release-resources-bit
   vk:command-buffer-reset-flag-bits-max-enum
   vk:command-buffer-reset-flags vk:stencil-face-flag-bits
   vk:stencil-face-front-bit vk:stencil-face-back-bit
   vk:stencil-front-and-back vk:stencil-face-flag-bits-max-enum
   vk:stencil-face-flags vk:application-info
   vk:instance-create-info vk:allocation-callbacks
   vk:physical-device-features vk:format-properties
   vk:extent3-d vk:image-format-properties
   vk:physical-device-limits
   vk:physical-device-sparse-properties
   vk:physical-device-properties vk:queue-family-properties
   vk:memory-type vk:memory-heap
   vk:physical-device-memory-properties
   vk:device-queue-create-info vk:device-create-info
   vk:extension-properties vk:layer-properties vk:submit-info
   vk:memory-allocate-info vk:mapped-memory-range
   vk:memory-requirements vk:sparse-image-format-properties
   vk:sparse-image-memory-requirements vk:sparse-memory-bind
   vk:sparse-buffer-memory-bind-info
   vk:sparse-image-opaque-memory-bind-info vk:image-subresource
   vk:offset3-d vk:sparse-image-memory-bind
   vk:sparse-image-memory-bind-info vk:bind-sparse-info
   vk:fence-create-info vk:semaphore-create-info
   vk:event-create-info vk:query-pool-create-info
   vk:buffer-create-info vk:buffer-view-create-info
   vk:image-create-info vk:subresource-layout
   vk:component-mapping vk:image-subresource-range
   vk:image-view-create-info vk:shader-module-create-info
   vk:pipeline-cache-create-info vk:specialization-map-entry
   vk:specialization-info vk:pipeline-shader-stage-create-info
   vk:vertex-input-binding-description
   vk:vertex-input-attribute-description
   vk:pipeline-vertex-input-state-create-info
   vk:pipeline-input-assembly-state-create-info
   vk:pipeline-tessellation-state-create-info vk:viewport
   vk:offset2-d vk:extent2-d vk:rect2-d
   vk:pipeline-viewport-state-create-info
   vk:pipeline-rasterization-state-create-info
   vk:pipeline-multisample-state-create-info
   vk:stencil-op-state
   vk:pipeline-depth-stencil-state-create-info
   vk:pipeline-color-blend-attachment-state
   vk:pipeline-color-blend-state-create-info
   vk:pipeline-dynamic-state-create-info
   vk:graphics-pipeline-create-info
   vk:compute-pipeline-create-info vk:push-constant-range
   vk:pipeline-layout-create-info vk:sampler-create-info
   vk:descriptor-set-layout-binding
   vk:descriptor-set-layout-create-info vk:descriptor-pool-size
   vk:descriptor-pool-create-info
   vk:descriptor-set-allocate-info vk:descriptor-image-info
   vk:descriptor-buffer-info vk:write-descriptor-set
   vk:copy-descriptor-set vk:framebuffer-create-info
   vk:attachment-description vk:attachment-reference
   vk:subpass-description vk:subpass-dependency
   vk:render-pass-create-info vk:command-pool-create-info
   vk:command-buffer-allocate-info
   vk:command-buffer-inheritance-info
   vk:command-buffer-begin-info vk:buffer-copy
   vk:image-subresource-layers vk:image-copy vk:image-blit
   vk:buffer-image-copy vk:clear-color-value
   vk:clear-depth-stencil-value vk:clear-value
   vk:clear-attachment vk:clear-rect vk:image-resolve
   vk:memory-barrier vk:buffer-memory-barrier
   vk:image-memory-barrier vk:render-pass-begin-info
   vk:dispatch-indirect-command
   vk:draw-indexed-indirect-command vk:draw-indirect-command
   vk:surface-khr vk:color-space-khr
   vk:color-space-srgb-nonlinear-khr
   vk:color-space-begin-range-khr vk:color-space-end-range-khr
   vk:color-space-range-size-khr vk:color-space-max-enum-khr
   vk:present-mode-khr vk:present-mode-immediate-khr
   vk:present-mode-mailbox-khr vk:present-mode-fifo-khr
   vk:present-mode-fifo-relaxed-khr
   vk:present-mode-begin-range-khr
   vk:present-mode-end-range-khr vk:present-mode-range-size-khr
   vk:present-mode-max-enum-khr
   vk:surface-transform-flag-bits-khr
   vk:surface-transform-identity-bit-khr
   vk:surface-transform-rotate-90-bit-khr
   vk:surface-transform-rotate-180-bit-khr
   vk:surface-transform-rotate-270-bit-khr
   vk:surface-transform-horizontal-mirror-bit-khr
   vk:surface-transform-horizontal-mirror-rotate-90-bit-khr
   vk:surface-transform-horizontal-mirror-rotate-180-bit-khr
   vk:surface-transform-horizontal-mirror-rotate-270-bit-khr
   vk:surface-transform-inherit-bit-khr
   vk:surface-transform-flag-bits-max-enum-khr
   vk:surface-transform-flags-khr
   vk:composite-alpha-flag-bits-khr
   vk:composite-alpha-opaque-bit-khr
   vk:composite-alpha-pre-multiplied-bit-khr
   vk:composite-alpha-post-multiplied-bit-khr
   vk:composite-alpha-inherit-bit-khr
   vk:composite-alpha-flag-bits-max-enum-khr
   vk:composite-alpha-flags-khr vk:surface-capabilities-khr
   vk:surface-format-khr vk:swapchain-khr
   vk:swapchain-create-flags-khr vk:swapchain-create-info-khr
   vk:present-info-khr vk:display-khr vk:display-mode-khr
   vk:display-plane-alpha-flag-bits-khr
   vk:display-plane-alpha-opaque-bit-khr
   vk:display-plane-alpha-global-bit-khr
   vk:display-plane-alpha-per-pixel-bit-khr
   vk:display-plane-alpha-per-pixel-premultiplied-bit-khr
   vk:display-plane-alpha-flag-bits-max-enum-khr
   vk:display-plane-alpha-flags-khr
   vk:display-mode-create-flags-khr
   vk:display-surface-create-flags-khr
   vk:display-properties-khr vk:display-mode-parameters-khr
   vk:display-mode-properties-khr
   vk:display-mode-create-info-khr
   vk:display-plane-capabilities-khr
   vk:display-plane-properties-khr
   vk:display-surface-create-info-khr
   vk:display-present-info-khr vk:debug-report-callback-ext
   vk:debug-report-object-type-ext
   vk:debug-report-object-type-unknown-ext
   vk:debug-report-object-type-instance-ext
   vk:debug-report-object-type-physical-device-ext
   vk:debug-report-object-type-device-ext
   vk:debug-report-object-type-queue-ext
   vk:debug-report-object-type-semaphore-ext
   vk:debug-report-object-type-command-buffer-ext
   vk:debug-report-object-type-fence-ext
   vk:debug-report-object-type-device-memory-ext
   vk:debug-report-object-type-buffer-ext
   vk:debug-report-object-type-image-ext
   vk:debug-report-object-type-event-ext
   vk:debug-report-object-type-query-pool-ext
   vk:debug-report-object-type-buffer-view-ext
   vk:debug-report-object-type-image-view-ext
   vk:debug-report-object-type-shader-module-ext
   vk:debug-report-object-type-pipeline-cache-ext
   vk:debug-report-object-type-pipeline-layout-ext
   vk:debug-report-object-type-render-pass-ext
   vk:debug-report-object-type-pipeline-ext
   vk:debug-report-object-type-descriptor-set-layout-ext
   vk:debug-report-object-type-sampler-ext
   vk:debug-report-object-type-descriptor-pool-ext
   vk:debug-report-object-type-descriptor-set-ext
   vk:debug-report-object-type-framebuffer-ext
   vk:debug-report-object-type-command-pool-ext
   vk:debug-report-object-type-surface-khr-ext
   vk:debug-report-object-type-swapchain-khr-ext
   vk:debug-report-object-type-debug-report-ext
   vk:debug-report-object-type-begin-range-ext
   vk:debug-report-object-type-end-range-ext
   vk:debug-report-object-type-range-size-ext
   vk:debug-report-object-type-max-enum-ext
   vk:debug-report-error-ext vk:debug-report-error-none-ext
   vk:debug-report-error-callback-ref-ext
   vk:debug-report-error-begin-range-ext
   vk:debug-report-error-end-range-ext
   vk:debug-report-error-range-size-ext
   vk:debug-report-error-max-enum-ext
   vk:debug-report-flag-bits-ext
   vk:debug-report-information-bit-ext
   vk:debug-report-warning-bit-ext
   vk:debug-report-performance-warning-bit-ext
   vk:debug-report-error-bit-ext vk:debug-report-debug-bit-ext
   vk:debug-report-flag-bits-max-enum-ext
   vk:debug-report-flags-ext
   vk:debug-report-callback-create-info-ext
   vk:rasterization-order-amd vk:rasterization-order-strict-amd
   vk:rasterization-order-relaxed-amd
   vk:rasterization-order-begin-range-amd
   vk:rasterization-order-end-range-amd
   vk:rasterization-order-range-size-amd
   vk:rasterization-order-max-enum-amd
   vk:pipeline-rasterization-state-rasterization-order-amd
   vk:debug-marker-object-name-info-ext
   vk:debug-marker-object-tag-info-ext
   vk:debug-marker-marker-info-ext
   vk:dedicated-allocation-image-create-info-nv
   vk:dedicated-allocation-buffer-create-info-nv
   vk:dedicated-allocation-memory-allocate-info-nv
   vk:external-memory-handle-type-flag-bits-nv
   vk:external-memory-handle-type-opaque-win32-bit-nv
   vk:external-memory-handle-type-opaque-win32-kmt-bit-nv
   vk:external-memory-handle-type-d3d11-image-bit-nv
   vk:external-memory-handle-type-d3d11-image-kmt-bit-nv
   vk:external-memory-handle-type-flag-bits-max-enum-nv
   vk:external-memory-handle-type-flags-nv
   vk:external-memory-feature-flag-bits-nv
   vk:external-memory-feature-dedicated-only-bit-nv
   vk:external-memory-feature-exportable-bit-nv
   vk:external-memory-feature-importable-bit-nv
   vk:external-memory-feature-flag-bits-max-enum-nv
   vk:external-memory-feature-flags-nv
   vk:external-image-format-properties-nv
   vk:external-memory-image-create-info-nv
   vk:export-memory-allocate-info-nv vk:validation-check-ext
   vk:validation-check-all-ext
   vk:validation-check-begin-range-ext
   vk:validation-check-end-range-ext
   vk:validation-check-range-size-ext
   vk:validation-check-max-enum-ext vk:validation-flags-ext
   vk:create-instance vk:destroy-instance
   vk:enumerate-physical-devices
   vk:get-physical-device-features
   vk:get-physical-device-format-properties
   vk:get-physical-device-image-format-properties
   vk:get-physical-device-properties
   vk:get-physical-device-queue-family-properties
   vk:get-physical-device-memory-properties
   vk:get-instance-proc-addr vk:get-device-proc-addr
   vk:create-device vk:destroy-device
   vk:enumerate-instance-extension-properties
   vk:enumerate-device-extension-properties
   vk:enumerate-instance-layer-properties
   vk:enumerate-device-layer-properties vk:get-device-queue
   vk:queue-submit vk:queue-wait-idle vk:device-wait-idle
   vk:allocate-memory vk:free-memory vk:map-memory
   vk:unmap-memory vk:flush-mapped-memory-ranges
   vk:invalidate-mapped-memory-ranges
   vk:get-device-memory-commitment vk:bind-buffer-memory
   vk:bind-image-memory vk:get-buffer-memory-requirements
   vk:get-image-memory-requirements
   vk:get-image-sparse-memory-requirements
   vk:get-physical-device-sparse-image-format-properties
   vk:queue-bind-sparse vk:create-fence vk:destroy-fence
   vk:reset-fences vk:get-fence-status vk:wait-for-fences
   vk:create-semaphore vk:destroy-semaphore vk:create-event
   vk:destroy-event vk:get-event-status vk:set-event
   vk:reset-event vk:create-query-pool vk:destroy-query-pool
   vk:get-query-pool-results vk:create-buffer vk:destroy-buffer
   vk:create-buffer-view vk:destroy-buffer-view vk:create-image
   vk:destroy-image vk:get-image-subresource-layout
   vk:create-image-view vk:destroy-image-view
   vk:create-shader-module vk:destroy-shader-module
   vk:create-pipeline-cache vk:destroy-pipeline-cache
   vk:get-pipeline-cache-data vk:merge-pipeline-caches
   vk:create-graphics-pipelines vk:create-compute-pipelines
   vk:destroy-pipeline vk:create-pipeline-layout
   vk:destroy-pipeline-layout vk:create-sampler
   vk:destroy-sampler vk:create-descriptor-set-layout
   vk:destroy-descriptor-set-layout vk:create-descriptor-pool
   vk:destroy-descriptor-pool vk:reset-descriptor-pool
   vk:allocate-descriptor-sets vk:free-descriptor-sets
   vk:update-descriptor-sets vk:create-framebuffer
   vk:destroy-framebuffer vk:create-render-pass
   vk:destroy-render-pass vk:get-render-area-granularity
   vk:create-command-pool vk:destroy-command-pool
   vk:reset-command-pool vk:allocate-command-buffers
   vk:free-command-buffers vk:begin-command-buffer
   vk:end-command-buffer vk:reset-command-buffer
   vk:cmd-bind-pipeline vk:cmd-set-viewport vk:cmd-set-scissor
   vk:cmd-set-line-width vk:cmd-set-depth-bias
   vk:cmd-set-blend-constants vk:cmd-set-depth-bounds
   vk:cmd-set-stencil-compare-mask
   vk:cmd-set-stencil-write-mask vk:cmd-set-stencil-reference
   vk:cmd-bind-descriptor-sets vk:cmd-bind-index-buffer
   vk:cmd-bind-vertex-buffers vk:cmd-draw vk:cmd-draw-indexed
   vk:cmd-draw-indirect vk:cmd-draw-indexed-indirect
   vk:cmd-dispatch vk:cmd-dispatch-indirect vk:cmd-copy-buffer
   vk:cmd-copy-image vk:cmd-blit-image
   vk:cmd-copy-buffer-to-image vk:cmd-copy-image-to-buffer
   vk:cmd-update-buffer vk:cmd-fill-buffer
   vk:cmd-clear-color-image vk:cmd-clear-depth-stencil-image
   vk:cmd-clear-attachments vk:cmd-resolve-image
   vk:cmd-set-event vk:cmd-reset-event vk:cmd-wait-events
   vk:cmd-pipeline-barrier vk:cmd-begin-query vk:cmd-end-query
   vk:cmd-reset-query-pool vk:cmd-write-timestamp
   vk:cmd-copy-query-pool-results vk:cmd-push-constants
   vk:cmd-begin-render-pass vk:cmd-next-subpass
   vk:cmd-end-render-pass vk:cmd-execute-commands
   vk:destroy-surface-khr
   vk:get-physical-device-surface-support-khr
   vk:get-physical-device-surface-capabilities-khr
   vk:get-physical-device-surface-formats-khr
   vk:get-physical-device-surface-present-modes-khr
   vk:create-swapchain-khr vk:destroy-swapchain-khr
   vk:get-swapchain-images-khr vk:acquire-next-image-khr
   vk:queue-present-khr
   vk:get-physical-device-display-properties-khr
   vk:get-physical-device-display-plane-properties-khr
   vk:get-display-plane-supported-displays-khr
   vk:get-display-mode-properties-khr
   vk:create-display-mode-khr
   vk:get-display-plane-capabilities-khr
   vk:create-display-plane-surface-khr
   vk:create-shared-swapchains-khr
   vk:get-physical-device-external-image-format-properties-nv)
  (import (scheme))
  (define-ftype integer-128
    (struct [lo unsigned-64] [hi integer-64]))
  (define-ftype unsigned-128
    (struct [lo unsigned-64] [hi unsigned-64]))
  (define-ftype enum int)
  (define-ftype int128-t integer-128)
  (define-ftype uint128-t unsigned-128)
  (define-ftype builtin-ms-va-list uptr)
  (define-ftype ptrdiff-t integer-64)
  (define-ftype size-t unsigned-64)
  (define-ftype wchar-t integer-32)
  (define-ftype int8-t integer-8)
  (define-ftype int16-t integer-16)
  (define-ftype int32-t integer-32)
  (define-ftype int64-t integer-64)
  (define-ftype uint8-t unsigned-8)
  (define-ftype uint16-t unsigned-16)
  (define-ftype uint32-t unsigned-32)
  (define-ftype uint64-t unsigned-64)
  (define-ftype int-least8-t integer-8)
  (define-ftype int-least16-t integer-16)
  (define-ftype int-least32-t integer-32)
  (define-ftype int-least64-t integer-64)
  (define-ftype uint-least8-t unsigned-8)
  (define-ftype uint-least16-t unsigned-16)
  (define-ftype uint-least32-t unsigned-32)
  (define-ftype uint-least64-t unsigned-64)
  (define-ftype int-fast8-t integer-8)
  (define-ftype int-fast16-t integer-64)
  (define-ftype int-fast32-t integer-64)
  (define-ftype int-fast64-t integer-64)
  (define-ftype uint-fast8-t unsigned-8)
  (define-ftype uint-fast16-t unsigned-64)
  (define-ftype uint-fast32-t unsigned-64)
  (define-ftype uint-fast64-t unsigned-64)
  (define-ftype intptr-t integer-64)
  (define-ftype uintptr-t unsigned-64)
  (define-ftype intmax-t integer-64)
  (define-ftype uintmax-t unsigned-64)
  (define-ftype vk:flags uint32-t)
  (define-ftype vk:bool32 uint32-t)
  (define-ftype vk:device-size uint64-t)
  (define-ftype vk:sample-mask uint32-t)
  (define-ftype vk:instance uptr)
  (define-ftype vk:physical-device uptr)
  (define-ftype vk:device uptr)
  (define-ftype vk:queue uptr)
  (define-ftype vk:semaphore uptr)
  (define-ftype vk:command-buffer uptr)
  (define-ftype vk:fence uptr)
  (define-ftype vk:device-memory uptr)
  (define-ftype vk:buffer uptr)
  (define-ftype vk:image uptr)
  (define-ftype vk:event uptr)
  (define-ftype vk:query-pool uptr)
  (define-ftype vk:buffer-view uptr)
  (define-ftype vk:image-view uptr)
  (define-ftype vk:shader-module uptr)
  (define-ftype vk:pipeline-cache uptr)
  (define-ftype vk:pipeline-layout uptr)
  (define-ftype vk:render-pass uptr)
  (define-ftype vk:pipeline uptr)
  (define-ftype vk:descriptor-set-layout uptr)
  (define-ftype vk:sampler uptr)
  (define-ftype vk:descriptor-pool uptr)
  (define-ftype vk:descriptor-set uptr)
  (define-ftype vk:framebuffer uptr)
  (define-ftype vk:command-pool uptr)
  (define-ftype vk:pipeline-cache-header-version enum)
  (define vk:pipeline-cache-header-version-one 1)
  (define vk:pipeline-cache-header-version-begin-range 1)
  (define vk:pipeline-cache-header-version-end-range 1)
  (define vk:pipeline-cache-header-version-range-size 1)
  (define vk:pipeline-cache-header-version-max-enum
    2147483647)
  (define-ftype vk:result enum)
  (define vk:success 0)
  (define vk:not-ready 1)
  (define vk:timeout 2)
  (define vk:event-set 3)
  (define vk:event-reset 4)
  (define vk:incomplete 5)
  (define vk:error-out-of-host-memory -1)
  (define vk:error-out-of-device-memory -2)
  (define vk:error-initialization-failed -3)
  (define vk:error-device-lost -4)
  (define vk:error-memory-map-failed -5)
  (define vk:error-layer-not-present -6)
  (define vk:error-extension-not-present -7)
  (define vk:error-feature-not-present -8)
  (define vk:error-incompatible-driver -9)
  (define vk:error-too-many-objects -10)
  (define vk:error-format-not-supported -11)
  (define vk:error-fragmented-pool -12)
  (define vk:error-surface-lost-khr -1000000000)
  (define vk:error-native-window-in-use-khr -1000000001)
  (define vk:suboptimal-khr 1000001003)
  (define vk:error-out-of-date-khr -1000001004)
  (define vk:error-incompatible-display-khr -1000003001)
  (define vk:error-validation-failed-ext -1000011001)
  (define vk:error-invalid-shader-nv -1000012000)
  (define vk:result-begin-range -12)
  (define vk:result-end-range 5)
  (define vk:result-range-size 18)
  (define vk:result-max-enum 2147483647)
  (define-ftype vk:structure-type enum)
  (define vk:structure-type-application-info 0)
  (define vk:structure-type-instance-create-info 1)
  (define vk:structure-type-device-queue-create-info 2)
  (define vk:structure-type-device-create-info 3)
  (define vk:structure-type-submit-info 4)
  (define vk:structure-type-memory-allocate-info 5)
  (define vk:structure-type-mapped-memory-range 6)
  (define vk:structure-type-bind-sparse-info 7)
  (define vk:structure-type-fence-create-info 8)
  (define vk:structure-type-semaphore-create-info 9)
  (define vk:structure-type-event-create-info 10)
  (define vk:structure-type-query-pool-create-info 11)
  (define vk:structure-type-buffer-create-info 12)
  (define vk:structure-type-buffer-view-create-info 13)
  (define vk:structure-type-image-create-info 14)
  (define vk:structure-type-image-view-create-info 15)
  (define vk:structure-type-shader-module-create-info 16)
  (define vk:structure-type-pipeline-cache-create-info 17)
  (define vk:structure-type-pipeline-shader-stage-create-info
    18)
  (define vk:structure-type-pipeline-vertex-input-state-create-info
    19)
  (define vk:structure-type-pipeline-input-assembly-state-create-info
    20)
  (define vk:structure-type-pipeline-tessellation-state-create-info
    21)
  (define vk:structure-type-pipeline-viewport-state-create-info
    22)
  (define vk:structure-type-pipeline-rasterization-state-create-info
    23)
  (define vk:structure-type-pipeline-multisample-state-create-info
    24)
  (define vk:structure-type-pipeline-depth-stencil-state-create-info
    25)
  (define vk:structure-type-pipeline-color-blend-state-create-info
    26)
  (define vk:structure-type-pipeline-dynamic-state-create-info
    27)
  (define vk:structure-type-graphics-pipeline-create-info 28)
  (define vk:structure-type-compute-pipeline-create-info 29)
  (define vk:structure-type-pipeline-layout-create-info 30)
  (define vk:structure-type-sampler-create-info 31)
  (define vk:structure-type-descriptor-set-layout-create-info
    32)
  (define vk:structure-type-descriptor-pool-create-info 33)
  (define vk:structure-type-descriptor-set-allocate-info 34)
  (define vk:structure-type-write-descriptor-set 35)
  (define vk:structure-type-copy-descriptor-set 36)
  (define vk:structure-type-framebuffer-create-info 37)
  (define vk:structure-type-render-pass-create-info 38)
  (define vk:structure-type-command-pool-create-info 39)
  (define vk:structure-type-command-buffer-allocate-info 40)
  (define vk:structure-type-command-buffer-inheritance-info
    41)
  (define vk:structure-type-command-buffer-begin-info 42)
  (define vk:structure-type-render-pass-begin-info 43)
  (define vk:structure-type-buffer-memory-barrier 44)
  (define vk:structure-type-image-memory-barrier 45)
  (define vk:structure-type-memory-barrier 46)
  (define vk:structure-type-loader-instance-create-info 47)
  (define vk:structure-type-loader-device-create-info 48)
  (define vk:structure-type-swapchain-create-info-khr
    1000001000)
  (define vk:structure-type-present-info-khr 1000001001)
  (define vk:structure-type-display-mode-create-info-khr
    1000002000)
  (define vk:structure-type-display-surface-create-info-khr
    1000002001)
  (define vk:structure-type-display-present-info-khr
    1000003000)
  (define vk:structure-type-xlib-surface-create-info-khr
    1000004000)
  (define vk:structure-type-xcb-surface-create-info-khr
    1000005000)
  (define vk:structure-type-wayland-surface-create-info-khr
    1000006000)
  (define vk:structure-type-mir-surface-create-info-khr
    1000007000)
  (define vk:structure-type-android-surface-create-info-khr
    1000008000)
  (define vk:structure-type-win32-surface-create-info-khr
    1000009000)
  (define vk:structure-type-debug-report-callback-create-info-ext
    1000011000)
  (define vk:structure-type-pipeline-rasterization-state-rasterization-order-amd
    1000018000)
  (define vk:structure-type-debug-marker-object-name-info-ext
    1000022000)
  (define vk:structure-type-debug-marker-object-tag-info-ext
    1000022001)
  (define vk:structure-type-debug-marker-marker-info-ext
    1000022002)
  (define vk:structure-type-dedicated-allocation-image-create-info-nv
    1000026000)
  (define vk:structure-type-dedicated-allocation-buffer-create-info-nv
    1000026001)
  (define vk:structure-type-dedicated-allocation-memory-allocate-info-nv
    1000026002)
  (define vk:structure-type-external-memory-image-create-info-nv
    1000056000)
  (define vk:structure-type-export-memory-allocate-info-nv
    1000056001)
  (define vk:structure-type-import-memory-win32-handle-info-nv
    1000057000)
  (define vk:structure-type-export-memory-win32-handle-info-nv
    1000057001)
  (define vk:structure-type-win32-keyed-mutex-acquire-release-info-nv
    1000058000)
  (define vk:structure-type-validation-flags-ext 1000061000)
  (define vk:structure-type-begin-range 0)
  (define vk:structure-type-end-range 48)
  (define vk:structure-type-range-size 49)
  (define vk:structure-type-max-enum 2147483647)
  (define-ftype vk:system-allocation-scope enum)
  (define vk:system-allocation-scope-command 0)
  (define vk:system-allocation-scope-object 1)
  (define vk:system-allocation-scope-cache 2)
  (define vk:system-allocation-scope-device 3)
  (define vk:system-allocation-scope-instance 4)
  (define vk:system-allocation-scope-begin-range 0)
  (define vk:system-allocation-scope-end-range 4)
  (define vk:system-allocation-scope-range-size 5)
  (define vk:system-allocation-scope-max-enum 2147483647)
  (define-ftype vk:internal-allocation-type enum)
  (define vk:internal-allocation-type-executable 0)
  (define vk:internal-allocation-type-begin-range 0)
  (define vk:internal-allocation-type-end-range 0)
  (define vk:internal-allocation-type-range-size 1)
  (define vk:internal-allocation-type-max-enum 2147483647)
  (define-ftype vk:format enum)
  (define vk:format-undefined 0)
  (define vk:format-r4g4-unorm-pack8 1)
  (define vk:format-r4g4b4a4-unorm-pack16 2)
  (define vk:format-b4g4r4a4-unorm-pack16 3)
  (define vk:format-r5g6b5-unorm-pack16 4)
  (define vk:format-b5g6r5-unorm-pack16 5)
  (define vk:format-r5g5b5a1-unorm-pack16 6)
  (define vk:format-b5g5r5a1-unorm-pack16 7)
  (define vk:format-a1r5g5b5-unorm-pack16 8)
  (define vk:format-r8-unorm 9)
  (define vk:format-r8-snorm 10)
  (define vk:format-r8-uscaled 11)
  (define vk:format-r8-sscaled 12)
  (define vk:format-r8-uint 13)
  (define vk:format-r8-sint 14)
  (define vk:format-r8-srgb 15)
  (define vk:format-r8g8-unorm 16)
  (define vk:format-r8g8-snorm 17)
  (define vk:format-r8g8-uscaled 18)
  (define vk:format-r8g8-sscaled 19)
  (define vk:format-r8g8-uint 20)
  (define vk:format-r8g8-sint 21)
  (define vk:format-r8g8-srgb 22)
  (define vk:format-r8g8b8-unorm 23)
  (define vk:format-r8g8b8-snorm 24)
  (define vk:format-r8g8b8-uscaled 25)
  (define vk:format-r8g8b8-sscaled 26)
  (define vk:format-r8g8b8-uint 27)
  (define vk:format-r8g8b8-sint 28)
  (define vk:format-r8g8b8-srgb 29)
  (define vk:format-b8g8r8-unorm 30)
  (define vk:format-b8g8r8-snorm 31)
  (define vk:format-b8g8r8-uscaled 32)
  (define vk:format-b8g8r8-sscaled 33)
  (define vk:format-b8g8r8-uint 34)
  (define vk:format-b8g8r8-sint 35)
  (define vk:format-b8g8r8-srgb 36)
  (define vk:format-r8g8b8a8-unorm 37)
  (define vk:format-r8g8b8a8-snorm 38)
  (define vk:format-r8g8b8a8-uscaled 39)
  (define vk:format-r8g8b8a8-sscaled 40)
  (define vk:format-r8g8b8a8-uint 41)
  (define vk:format-r8g8b8a8-sint 42)
  (define vk:format-r8g8b8a8-srgb 43)
  (define vk:format-b8g8r8a8-unorm 44)
  (define vk:format-b8g8r8a8-snorm 45)
  (define vk:format-b8g8r8a8-uscaled 46)
  (define vk:format-b8g8r8a8-sscaled 47)
  (define vk:format-b8g8r8a8-uint 48)
  (define vk:format-b8g8r8a8-sint 49)
  (define vk:format-b8g8r8a8-srgb 50)
  (define vk:format-a8b8g8r8-unorm-pack32 51)
  (define vk:format-a8b8g8r8-snorm-pack32 52)
  (define vk:format-a8b8g8r8-uscaled-pack32 53)
  (define vk:format-a8b8g8r8-sscaled-pack32 54)
  (define vk:format-a8b8g8r8-uint-pack32 55)
  (define vk:format-a8b8g8r8-sint-pack32 56)
  (define vk:format-a8b8g8r8-srgb-pack32 57)
  (define vk:format-a2r10g10b10-unorm-pack32 58)
  (define vk:format-a2r10g10b10-snorm-pack32 59)
  (define vk:format-a2r10g10b10-uscaled-pack32 60)
  (define vk:format-a2r10g10b10-sscaled-pack32 61)
  (define vk:format-a2r10g10b10-uint-pack32 62)
  (define vk:format-a2r10g10b10-sint-pack32 63)
  (define vk:format-a2b10g10r10-unorm-pack32 64)
  (define vk:format-a2b10g10r10-snorm-pack32 65)
  (define vk:format-a2b10g10r10-uscaled-pack32 66)
  (define vk:format-a2b10g10r10-sscaled-pack32 67)
  (define vk:format-a2b10g10r10-uint-pack32 68)
  (define vk:format-a2b10g10r10-sint-pack32 69)
  (define vk:format-r16-unorm 70)
  (define vk:format-r16-snorm 71)
  (define vk:format-r16-uscaled 72)
  (define vk:format-r16-sscaled 73)
  (define vk:format-r16-uint 74)
  (define vk:format-r16-sint 75)
  (define vk:format-r16-sfloat 76)
  (define vk:format-r16g16-unorm 77)
  (define vk:format-r16g16-snorm 78)
  (define vk:format-r16g16-uscaled 79)
  (define vk:format-r16g16-sscaled 80)
  (define vk:format-r16g16-uint 81)
  (define vk:format-r16g16-sint 82)
  (define vk:format-r16g16-sfloat 83)
  (define vk:format-r16g16b16-unorm 84)
  (define vk:format-r16g16b16-snorm 85)
  (define vk:format-r16g16b16-uscaled 86)
  (define vk:format-r16g16b16-sscaled 87)
  (define vk:format-r16g16b16-uint 88)
  (define vk:format-r16g16b16-sint 89)
  (define vk:format-r16g16b16-sfloat 90)
  (define vk:format-r16g16b16a16-unorm 91)
  (define vk:format-r16g16b16a16-snorm 92)
  (define vk:format-r16g16b16a16-uscaled 93)
  (define vk:format-r16g16b16a16-sscaled 94)
  (define vk:format-r16g16b16a16-uint 95)
  (define vk:format-r16g16b16a16-sint 96)
  (define vk:format-r16g16b16a16-sfloat 97)
  (define vk:format-r32-uint 98)
  (define vk:format-r32-sint 99)
  (define vk:format-r32-sfloat 100)
  (define vk:format-r32g32-uint 101)
  (define vk:format-r32g32-sint 102)
  (define vk:format-r32g32-sfloat 103)
  (define vk:format-r32g32b32-uint 104)
  (define vk:format-r32g32b32-sint 105)
  (define vk:format-r32g32b32-sfloat 106)
  (define vk:format-r32g32b32a32-uint 107)
  (define vk:format-r32g32b32a32-sint 108)
  (define vk:format-r32g32b32a32-sfloat 109)
  (define vk:format-r64-uint 110)
  (define vk:format-r64-sint 111)
  (define vk:format-r64-sfloat 112)
  (define vk:format-r64g64-uint 113)
  (define vk:format-r64g64-sint 114)
  (define vk:format-r64g64-sfloat 115)
  (define vk:format-r64g64b64-uint 116)
  (define vk:format-r64g64b64-sint 117)
  (define vk:format-r64g64b64-sfloat 118)
  (define vk:format-r64g64b64a64-uint 119)
  (define vk:format-r64g64b64a64-sint 120)
  (define vk:format-r64g64b64a64-sfloat 121)
  (define vk:format-b10g11r11-ufloat-pack32 122)
  (define vk:format-e5b9g9r9-ufloat-pack32 123)
  (define vk:format-d16-unorm 124)
  (define vk:format-x8-d24-unorm-pack32 125)
  (define vk:format-d32-sfloat 126)
  (define vk:format-s8-uint 127)
  (define vk:format-d16-unorm-s8-uint 128)
  (define vk:format-d24-unorm-s8-uint 129)
  (define vk:format-d32-sfloat-s8-uint 130)
  (define vk:format-bc1-rgb-unorm-block 131)
  (define vk:format-bc1-rgb-srgb-block 132)
  (define vk:format-bc1-rgba-unorm-block 133)
  (define vk:format-bc1-rgba-srgb-block 134)
  (define vk:format-bc2-unorm-block 135)
  (define vk:format-bc2-srgb-block 136)
  (define vk:format-bc3-unorm-block 137)
  (define vk:format-bc3-srgb-block 138)
  (define vk:format-bc4-unorm-block 139)
  (define vk:format-bc4-snorm-block 140)
  (define vk:format-bc5-unorm-block 141)
  (define vk:format-bc5-snorm-block 142)
  (define vk:format-bc6h-ufloat-block 143)
  (define vk:format-bc6h-sfloat-block 144)
  (define vk:format-bc7-unorm-block 145)
  (define vk:format-bc7-srgb-block 146)
  (define vk:format-etc2-r8g8b8-unorm-block 147)
  (define vk:format-etc2-r8g8b8-srgb-block 148)
  (define vk:format-etc2-r8g8b8a1-unorm-block 149)
  (define vk:format-etc2-r8g8b8a1-srgb-block 150)
  (define vk:format-etc2-r8g8b8a8-unorm-block 151)
  (define vk:format-etc2-r8g8b8a8-srgb-block 152)
  (define vk:format-eac-r11-unorm-block 153)
  (define vk:format-eac-r11-snorm-block 154)
  (define vk:format-eac-r11g11-unorm-block 155)
  (define vk:format-eac-r11g11-snorm-block 156)
  (define vk:format-astc-4x4-unorm-block 157)
  (define vk:format-astc-4x4-srgb-block 158)
  (define vk:format-astc-5x4-unorm-block 159)
  (define vk:format-astc-5x4-srgb-block 160)
  (define vk:format-astc-5x5-unorm-block 161)
  (define vk:format-astc-5x5-srgb-block 162)
  (define vk:format-astc-6x5-unorm-block 163)
  (define vk:format-astc-6x5-srgb-block 164)
  (define vk:format-astc-6x6-unorm-block 165)
  (define vk:format-astc-6x6-srgb-block 166)
  (define vk:format-astc-8x5-unorm-block 167)
  (define vk:format-astc-8x5-srgb-block 168)
  (define vk:format-astc-8x6-unorm-block 169)
  (define vk:format-astc-8x6-srgb-block 170)
  (define vk:format-astc-8x8-unorm-block 171)
  (define vk:format-astc-8x8-srgb-block 172)
  (define vk:format-astc-10x5-unorm-block 173)
  (define vk:format-astc-10x5-srgb-block 174)
  (define vk:format-astc-10x6-unorm-block 175)
  (define vk:format-astc-10x6-srgb-block 176)
  (define vk:format-astc-10x8-unorm-block 177)
  (define vk:format-astc-10x8-srgb-block 178)
  (define vk:format-astc-10x10-unorm-block 179)
  (define vk:format-astc-10x10-srgb-block 180)
  (define vk:format-astc-12x10-unorm-block 181)
  (define vk:format-astc-12x10-srgb-block 182)
  (define vk:format-astc-12x12-unorm-block 183)
  (define vk:format-astc-12x12-srgb-block 184)
  (define vk:format-pvrtc1-2bpp-unorm-block-img 1000054000)
  (define vk:format-pvrtc1-4bpp-unorm-block-img 1000054001)
  (define vk:format-pvrtc2-2bpp-unorm-block-img 1000054002)
  (define vk:format-pvrtc2-4bpp-unorm-block-img 1000054003)
  (define vk:format-pvrtc1-2bpp-srgb-block-img 1000054004)
  (define vk:format-pvrtc1-4bpp-srgb-block-img 1000054005)
  (define vk:format-pvrtc2-2bpp-srgb-block-img 1000054006)
  (define vk:format-pvrtc2-4bpp-srgb-block-img 1000054007)
  (define vk:format-begin-range 0)
  (define vk:format-end-range 184)
  (define vk:format-range-size 185)
  (define vk:format-max-enum 2147483647)
  (define-ftype vk:image-type enum)
  (define vk:image-type-1d 0)
  (define vk:image-type-2d 1)
  (define vk:image-type-3d 2)
  (define vk:image-type-begin-range 0)
  (define vk:image-type-end-range 2)
  (define vk:image-type-range-size 3)
  (define vk:image-type-max-enum 2147483647)
  (define-ftype vk:image-tiling enum)
  (define vk:image-tiling-optimal 0)
  (define vk:image-tiling-linear 1)
  (define vk:image-tiling-begin-range 0)
  (define vk:image-tiling-end-range 1)
  (define vk:image-tiling-range-size 2)
  (define vk:image-tiling-max-enum 2147483647)
  (define-ftype vk:physical-device-type enum)
  (define vk:physical-device-type-other 0)
  (define vk:physical-device-type-integrated-gpu 1)
  (define vk:physical-device-type-discrete-gpu 2)
  (define vk:physical-device-type-virtual-gpu 3)
  (define vk:physical-device-type-cpu 4)
  (define vk:physical-device-type-begin-range 0)
  (define vk:physical-device-type-end-range 4)
  (define vk:physical-device-type-range-size 5)
  (define vk:physical-device-type-max-enum 2147483647)
  (define-ftype vk:query-type enum)
  (define vk:query-type-occlusion 0)
  (define vk:query-type-pipeline-statistics 1)
  (define vk:query-type-timestamp 2)
  (define vk:query-type-begin-range 0)
  (define vk:query-type-end-range 2)
  (define vk:query-type-range-size 3)
  (define vk:query-type-max-enum 2147483647)
  (define-ftype vk:sharing-mode enum)
  (define vk:sharing-mode-exclusive 0)
  (define vk:sharing-mode-concurrent 1)
  (define vk:sharing-mode-begin-range 0)
  (define vk:sharing-mode-end-range 1)
  (define vk:sharing-mode-range-size 2)
  (define vk:sharing-mode-max-enum 2147483647)
  (define-ftype vk:image-layout enum)
  (define vk:image-layout-undefined 0)
  (define vk:image-layout-general 1)
  (define vk:image-layout-color-attachment-optimal 2)
  (define vk:image-layout-depth-stencil-attachment-optimal 3)
  (define vk:image-layout-depth-stencil-read-only-optimal 4)
  (define vk:image-layout-shader-read-only-optimal 5)
  (define vk:image-layout-transfer-src-optimal 6)
  (define vk:image-layout-transfer-dst-optimal 7)
  (define vk:image-layout-preinitialized 8)
  (define vk:image-layout-present-src-khr 1000001002)
  (define vk:image-layout-begin-range 0)
  (define vk:image-layout-end-range 8)
  (define vk:image-layout-range-size 9)
  (define vk:image-layout-max-enum 2147483647)
  (define-ftype vk:image-view-type enum)
  (define vk:image-view-type-1d 0)
  (define vk:image-view-type-2d 1)
  (define vk:image-view-type-3d 2)
  (define vk:image-view-type-cube 3)
  (define vk:image-view-type-1d-array 4)
  (define vk:image-view-type-2d-array 5)
  (define vk:image-view-type-cube-array 6)
  (define vk:image-view-type-begin-range 0)
  (define vk:image-view-type-end-range 6)
  (define vk:image-view-type-range-size 7)
  (define vk:image-view-type-max-enum 2147483647)
  (define-ftype vk:component-swizzle enum)
  (define vk:component-swizzle-identity 0)
  (define vk:component-swizzle-zero 1)
  (define vk:component-swizzle-one 2)
  (define vk:component-swizzle-r 3)
  (define vk:component-swizzle-g 4)
  (define vk:component-swizzle-b 5)
  (define vk:component-swizzle-a 6)
  (define vk:component-swizzle-begin-range 0)
  (define vk:component-swizzle-end-range 6)
  (define vk:component-swizzle-range-size 7)
  (define vk:component-swizzle-max-enum 2147483647)
  (define-ftype vk:vertex-input-rate enum)
  (define vk:vertex-input-rate-vertex 0)
  (define vk:vertex-input-rate-instance 1)
  (define vk:vertex-input-rate-begin-range 0)
  (define vk:vertex-input-rate-end-range 1)
  (define vk:vertex-input-rate-range-size 2)
  (define vk:vertex-input-rate-max-enum 2147483647)
  (define-ftype vk:primitive-topology enum)
  (define vk:primitive-topology-point-list 0)
  (define vk:primitive-topology-line-list 1)
  (define vk:primitive-topology-line-strip 2)
  (define vk:primitive-topology-triangle-list 3)
  (define vk:primitive-topology-triangle-strip 4)
  (define vk:primitive-topology-triangle-fan 5)
  (define vk:primitive-topology-line-list-with-adjacency 6)
  (define vk:primitive-topology-line-strip-with-adjacency 7)
  (define vk:primitive-topology-triangle-list-with-adjacency
    8)
  (define vk:primitive-topology-triangle-strip-with-adjacency
    9)
  (define vk:primitive-topology-patch-list 10)
  (define vk:primitive-topology-begin-range 0)
  (define vk:primitive-topology-end-range 10)
  (define vk:primitive-topology-range-size 11)
  (define vk:primitive-topology-max-enum 2147483647)
  (define-ftype vk:polygon-mode enum)
  (define vk:polygon-mode-fill 0)
  (define vk:polygon-mode-line 1)
  (define vk:polygon-mode-point 2)
  (define vk:polygon-mode-begin-range 0)
  (define vk:polygon-mode-end-range 2)
  (define vk:polygon-mode-range-size 3)
  (define vk:polygon-mode-max-enum 2147483647)
  (define-ftype vk:front-face enum)
  (define vk:front-face-counter-clockwise 0)
  (define vk:front-face-clockwise 1)
  (define vk:front-face-begin-range 0)
  (define vk:front-face-end-range 1)
  (define vk:front-face-range-size 2)
  (define vk:front-face-max-enum 2147483647)
  (define-ftype vk:compare-op enum)
  (define vk:compare-op-never 0)
  (define vk:compare-op-less 1)
  (define vk:compare-op-equal 2)
  (define vk:compare-op-less-or-equal 3)
  (define vk:compare-op-greater 4)
  (define vk:compare-op-not-equal 5)
  (define vk:compare-op-greater-or-equal 6)
  (define vk:compare-op-always 7)
  (define vk:compare-op-begin-range 0)
  (define vk:compare-op-end-range 7)
  (define vk:compare-op-range-size 8)
  (define vk:compare-op-max-enum 2147483647)
  (define-ftype vk:stencil-op enum)
  (define vk:stencil-op-keep 0)
  (define vk:stencil-op-zero 1)
  (define vk:stencil-op-replace 2)
  (define vk:stencil-op-increment-and-clamp 3)
  (define vk:stencil-op-decrement-and-clamp 4)
  (define vk:stencil-op-invert 5)
  (define vk:stencil-op-increment-and-wrap 6)
  (define vk:stencil-op-decrement-and-wrap 7)
  (define vk:stencil-op-begin-range 0)
  (define vk:stencil-op-end-range 7)
  (define vk:stencil-op-range-size 8)
  (define vk:stencil-op-max-enum 2147483647)
  (define-ftype vk:logic-op enum)
  (define vk:logic-op-clear 0)
  (define vk:logic-op-and 1)
  (define vk:logic-op-and-reverse 2)
  (define vk:logic-op-copy 3)
  (define vk:logic-op-and-inverted 4)
  (define vk:logic-op-no-op 5)
  (define vk:logic-op-xor 6)
  (define vk:logic-op-or 7)
  (define vk:logic-op-nor 8)
  (define vk:logic-op-equivalent 9)
  (define vk:logic-op-invert 10)
  (define vk:logic-op-or-reverse 11)
  (define vk:logic-op-copy-inverted 12)
  (define vk:logic-op-or-inverted 13)
  (define vk:logic-op-nand 14)
  (define vk:logic-op-set 15)
  (define vk:logic-op-begin-range 0)
  (define vk:logic-op-end-range 15)
  (define vk:logic-op-range-size 16)
  (define vk:logic-op-max-enum 2147483647)
  (define-ftype vk:blend-factor enum)
  (define vk:blend-factor-zero 0)
  (define vk:blend-factor-one 1)
  (define vk:blend-factor-src-color 2)
  (define vk:blend-factor-one-minus-src-color 3)
  (define vk:blend-factor-dst-color 4)
  (define vk:blend-factor-one-minus-dst-color 5)
  (define vk:blend-factor-src-alpha 6)
  (define vk:blend-factor-one-minus-src-alpha 7)
  (define vk:blend-factor-dst-alpha 8)
  (define vk:blend-factor-one-minus-dst-alpha 9)
  (define vk:blend-factor-constant-color 10)
  (define vk:blend-factor-one-minus-constant-color 11)
  (define vk:blend-factor-constant-alpha 12)
  (define vk:blend-factor-one-minus-constant-alpha 13)
  (define vk:blend-factor-src-alpha-saturate 14)
  (define vk:blend-factor-src1-color 15)
  (define vk:blend-factor-one-minus-src1-color 16)
  (define vk:blend-factor-src1-alpha 17)
  (define vk:blend-factor-one-minus-src1-alpha 18)
  (define vk:blend-factor-begin-range 0)
  (define vk:blend-factor-end-range 18)
  (define vk:blend-factor-range-size 19)
  (define vk:blend-factor-max-enum 2147483647)
  (define-ftype vk:blend-op enum)
  (define vk:blend-op-add 0)
  (define vk:blend-op-subtract 1)
  (define vk:blend-op-reverse-subtract 2)
  (define vk:blend-op-min 3)
  (define vk:blend-op-max 4)
  (define vk:blend-op-begin-range 0)
  (define vk:blend-op-end-range 4)
  (define vk:blend-op-range-size 5)
  (define vk:blend-op-max-enum 2147483647)
  (define-ftype vk:dynamic-state enum)
  (define vk:dynamic-state-viewport 0)
  (define vk:dynamic-state-scissor 1)
  (define vk:dynamic-state-line-width 2)
  (define vk:dynamic-state-depth-bias 3)
  (define vk:dynamic-state-blend-constants 4)
  (define vk:dynamic-state-depth-bounds 5)
  (define vk:dynamic-state-stencil-compare-mask 6)
  (define vk:dynamic-state-stencil-write-mask 7)
  (define vk:dynamic-state-stencil-reference 8)
  (define vk:dynamic-state-begin-range 0)
  (define vk:dynamic-state-end-range 8)
  (define vk:dynamic-state-range-size 9)
  (define vk:dynamic-state-max-enum 2147483647)
  (define-ftype vk:filter enum)
  (define vk:filter-nearest 0)
  (define vk:filter-linear 1)
  (define vk:filter-cubic-img 1000015000)
  (define vk:filter-begin-range 0)
  (define vk:filter-end-range 1)
  (define vk:filter-range-size 2)
  (define vk:filter-max-enum 2147483647)
  (define-ftype vk:sampler-mipmap-mode enum)
  (define vk:sampler-mipmap-mode-nearest 0)
  (define vk:sampler-mipmap-mode-linear 1)
  (define vk:sampler-mipmap-mode-begin-range 0)
  (define vk:sampler-mipmap-mode-end-range 1)
  (define vk:sampler-mipmap-mode-range-size 2)
  (define vk:sampler-mipmap-mode-max-enum 2147483647)
  (define-ftype vk:sampler-address-mode enum)
  (define vk:sampler-address-mode-repeat 0)
  (define vk:sampler-address-mode-mirrored-repeat 1)
  (define vk:sampler-address-mode-clamp-to-edge 2)
  (define vk:sampler-address-mode-clamp-to-border 3)
  (define vk:sampler-address-mode-mirror-clamp-to-edge 4)
  (define vk:sampler-address-mode-begin-range 0)
  (define vk:sampler-address-mode-end-range 3)
  (define vk:sampler-address-mode-range-size 4)
  (define vk:sampler-address-mode-max-enum 2147483647)
  (define-ftype vk:border-color enum)
  (define vk:border-color-float-transparent-black 0)
  (define vk:border-color-int-transparent-black 1)
  (define vk:border-color-float-opaque-black 2)
  (define vk:border-color-int-opaque-black 3)
  (define vk:border-color-float-opaque-white 4)
  (define vk:border-color-int-opaque-white 5)
  (define vk:border-color-begin-range 0)
  (define vk:border-color-end-range 5)
  (define vk:border-color-range-size 6)
  (define vk:border-color-max-enum 2147483647)
  (define-ftype vk:descriptor-type enum)
  (define vk:descriptor-type-sampler 0)
  (define vk:descriptor-type-combined-image-sampler 1)
  (define vk:descriptor-type-sampled-image 2)
  (define vk:descriptor-type-storage-image 3)
  (define vk:descriptor-type-uniform-texel-buffer 4)
  (define vk:descriptor-type-storage-texel-buffer 5)
  (define vk:descriptor-type-uniform-buffer 6)
  (define vk:descriptor-type-storage-buffer 7)
  (define vk:descriptor-type-uniform-buffer-dynamic 8)
  (define vk:descriptor-type-storage-buffer-dynamic 9)
  (define vk:descriptor-type-input-attachment 10)
  (define vk:descriptor-type-begin-range 0)
  (define vk:descriptor-type-end-range 10)
  (define vk:descriptor-type-range-size 11)
  (define vk:descriptor-type-max-enum 2147483647)
  (define-ftype vk:attachment-load-op enum)
  (define vk:attachment-load-op-load 0)
  (define vk:attachment-load-op-clear 1)
  (define vk:attachment-load-op-dont-care 2)
  (define vk:attachment-load-op-begin-range 0)
  (define vk:attachment-load-op-end-range 2)
  (define vk:attachment-load-op-range-size 3)
  (define vk:attachment-load-op-max-enum 2147483647)
  (define-ftype vk:attachment-store-op enum)
  (define vk:attachment-store-op-store 0)
  (define vk:attachment-store-op-dont-care 1)
  (define vk:attachment-store-op-begin-range 0)
  (define vk:attachment-store-op-end-range 1)
  (define vk:attachment-store-op-range-size 2)
  (define vk:attachment-store-op-max-enum 2147483647)
  (define-ftype vk:pipeline-bind-point enum)
  (define vk:pipeline-bind-point-graphics 0)
  (define vk:pipeline-bind-point-compute 1)
  (define vk:pipeline-bind-point-begin-range 0)
  (define vk:pipeline-bind-point-end-range 1)
  (define vk:pipeline-bind-point-range-size 2)
  (define vk:pipeline-bind-point-max-enum 2147483647)
  (define-ftype vk:command-buffer-level enum)
  (define vk:command-buffer-level-primary 0)
  (define vk:command-buffer-level-secondary 1)
  (define vk:command-buffer-level-begin-range 0)
  (define vk:command-buffer-level-end-range 1)
  (define vk:command-buffer-level-range-size 2)
  (define vk:command-buffer-level-max-enum 2147483647)
  (define-ftype vk:index-type enum)
  (define vk:index-type-uint16 0)
  (define vk:index-type-uint32 1)
  (define vk:index-type-begin-range 0)
  (define vk:index-type-end-range 1)
  (define vk:index-type-range-size 2)
  (define vk:index-type-max-enum 2147483647)
  (define-ftype vk:subpass-contents enum)
  (define vk:subpass-contents-inline 0)
  (define vk:subpass-contents-secondary-command-buffers 1)
  (define vk:subpass-contents-begin-range 0)
  (define vk:subpass-contents-end-range 1)
  (define vk:subpass-contents-range-size 2)
  (define vk:subpass-contents-max-enum 2147483647)
  (define-ftype vk:instance-create-flags vk:flags)
  (define-ftype vk:format-feature-flag-bits enum)
  (define vk:format-feature-sampled-image-bit 1)
  (define vk:format-feature-storage-image-bit 2)
  (define vk:format-feature-storage-image-atomic-bit 4)
  (define vk:format-feature-uniform-texel-buffer-bit 8)
  (define vk:format-feature-storage-texel-buffer-bit 16)
  (define vk:format-feature-storage-texel-buffer-atomic-bit
    32)
  (define vk:format-feature-vertex-buffer-bit 64)
  (define vk:format-feature-color-attachment-bit 128)
  (define vk:format-feature-color-attachment-blend-bit 256)
  (define vk:format-feature-depth-stencil-attachment-bit 512)
  (define vk:format-feature-blit-src-bit 1024)
  (define vk:format-feature-blit-dst-bit 2048)
  (define vk:format-feature-sampled-image-filter-linear-bit
    4096)
  (define vk:format-feature-sampled-image-filter-cubic-bit-img
    8192)
  (define vk:format-feature-flag-bits-max-enum 2147483647)
  (define-ftype vk:format-feature-flags vk:flags)
  (define-ftype vk:image-usage-flag-bits enum)
  (define vk:image-usage-transfer-src-bit 1)
  (define vk:image-usage-transfer-dst-bit 2)
  (define vk:image-usage-sampled-bit 4)
  (define vk:image-usage-storage-bit 8)
  (define vk:image-usage-color-attachment-bit 16)
  (define vk:image-usage-depth-stencil-attachment-bit 32)
  (define vk:image-usage-transient-attachment-bit 64)
  (define vk:image-usage-input-attachment-bit 128)
  (define vk:image-usage-flag-bits-max-enum 2147483647)
  (define-ftype vk:image-usage-flags vk:flags)
  (define-ftype vk:image-create-flag-bits enum)
  (define vk:image-create-sparse-binding-bit 1)
  (define vk:image-create-sparse-residency-bit 2)
  (define vk:image-create-sparse-aliased-bit 4)
  (define vk:image-create-mutable-format-bit 8)
  (define vk:image-create-cube-compatible-bit 16)
  (define vk:image-create-flag-bits-max-enum 2147483647)
  (define-ftype vk:image-create-flags vk:flags)
  (define-ftype vk:sample-count-flag-bits enum)
  (define vk:sample-count-1-bit 1)
  (define vk:sample-count-2-bit 2)
  (define vk:sample-count-4-bit 4)
  (define vk:sample-count-8-bit 8)
  (define vk:sample-count-16-bit 16)
  (define vk:sample-count-32-bit 32)
  (define vk:sample-count-64-bit 64)
  (define vk:sample-count-flag-bits-max-enum 2147483647)
  (define-ftype vk:sample-count-flags vk:flags)
  (define-ftype vk:queue-flag-bits enum)
  (define vk:queue-graphics-bit 1)
  (define vk:queue-compute-bit 2)
  (define vk:queue-transfer-bit 4)
  (define vk:queue-sparse-binding-bit 8)
  (define vk:queue-flag-bits-max-enum 2147483647)
  (define-ftype vk:queue-flags vk:flags)
  (define-ftype vk:memory-property-flag-bits enum)
  (define vk:memory-property-device-local-bit 1)
  (define vk:memory-property-host-visible-bit 2)
  (define vk:memory-property-host-coherent-bit 4)
  (define vk:memory-property-host-cached-bit 8)
  (define vk:memory-property-lazily-allocated-bit 16)
  (define vk:memory-property-flag-bits-max-enum 2147483647)
  (define-ftype vk:memory-property-flags vk:flags)
  (define-ftype vk:memory-heap-flag-bits enum)
  (define vk:memory-heap-device-local-bit 1)
  (define vk:memory-heap-flag-bits-max-enum 2147483647)
  (define-ftype vk:memory-heap-flags vk:flags)
  (define-ftype vk:device-create-flags vk:flags)
  (define-ftype vk:device-queue-create-flags vk:flags)
  (define-ftype vk:pipeline-stage-flag-bits enum)
  (define vk:pipeline-stage-top-of-pipe-bit 1)
  (define vk:pipeline-stage-draw-indirect-bit 2)
  (define vk:pipeline-stage-vertex-input-bit 4)
  (define vk:pipeline-stage-vertex-shader-bit 8)
  (define vk:pipeline-stage-tessellation-control-shader-bit
    16)
  (define vk:pipeline-stage-tessellation-evaluation-shader-bit
    32)
  (define vk:pipeline-stage-geometry-shader-bit 64)
  (define vk:pipeline-stage-fragment-shader-bit 128)
  (define vk:pipeline-stage-early-fragment-tests-bit 256)
  (define vk:pipeline-stage-late-fragment-tests-bit 512)
  (define vk:pipeline-stage-color-attachment-output-bit 1024)
  (define vk:pipeline-stage-compute-shader-bit 2048)
  (define vk:pipeline-stage-transfer-bit 4096)
  (define vk:pipeline-stage-bottom-of-pipe-bit 8192)
  (define vk:pipeline-stage-host-bit 16384)
  (define vk:pipeline-stage-all-graphics-bit 32768)
  (define vk:pipeline-stage-all-commands-bit 65536)
  (define vk:pipeline-stage-flag-bits-max-enum 2147483647)
  (define-ftype vk:pipeline-stage-flags vk:flags)
  (define-ftype vk:memory-map-flags vk:flags)
  (define-ftype vk:image-aspect-flag-bits enum)
  (define vk:image-aspect-color-bit 1)
  (define vk:image-aspect-depth-bit 2)
  (define vk:image-aspect-stencil-bit 4)
  (define vk:image-aspect-metadata-bit 8)
  (define vk:image-aspect-flag-bits-max-enum 2147483647)
  (define-ftype vk:image-aspect-flags vk:flags)
  (define-ftype vk:sparse-image-format-flag-bits enum)
  (define vk:sparse-image-format-single-miptail-bit 1)
  (define vk:sparse-image-format-aligned-mip-size-bit 2)
  (define vk:sparse-image-format-nonstandard-block-size-bit 4)
  (define vk:sparse-image-format-flag-bits-max-enum
    2147483647)
  (define-ftype vk:sparse-image-format-flags vk:flags)
  (define-ftype vk:sparse-memory-bind-flag-bits enum)
  (define vk:sparse-memory-bind-metadata-bit 1)
  (define vk:sparse-memory-bind-flag-bits-max-enum 2147483647)
  (define-ftype vk:sparse-memory-bind-flags vk:flags)
  (define-ftype vk:fence-create-flag-bits enum)
  (define vk:fence-create-signaled-bit 1)
  (define vk:fence-create-flag-bits-max-enum 2147483647)
  (define-ftype vk:fence-create-flags vk:flags)
  (define-ftype vk:semaphore-create-flags vk:flags)
  (define-ftype vk:event-create-flags vk:flags)
  (define-ftype vk:query-pool-create-flags vk:flags)
  (define-ftype vk:query-pipeline-statistic-flag-bits enum)
  (define vk:query-pipeline-statistic-input-assembly-vertices-bit
    1)
  (define vk:query-pipeline-statistic-input-assembly-primitives-bit
    2)
  (define vk:query-pipeline-statistic-vertex-shader-invocations-bit
    4)
  (define vk:query-pipeline-statistic-geometry-shader-invocations-bit
    8)
  (define vk:query-pipeline-statistic-geometry-shader-primitives-bit
    16)
  (define vk:query-pipeline-statistic-clipping-invocations-bit
    32)
  (define vk:query-pipeline-statistic-clipping-primitives-bit
    64)
  (define vk:query-pipeline-statistic-fragment-shader-invocations-bit
    128)
  (define vk:query-pipeline-statistic-tessellation-control-shader-patches-bit
    256)
  (define vk:query-pipeline-statistic-tessellation-evaluation-shader-invocations-bit
    512)
  (define vk:query-pipeline-statistic-compute-shader-invocations-bit
    1024)
  (define vk:query-pipeline-statistic-flag-bits-max-enum
    2147483647)
  (define-ftype vk:query-pipeline-statistic-flags vk:flags)
  (define-ftype vk:query-result-flag-bits enum)
  (define vk:query-result-64-bit 1)
  (define vk:query-result-wait-bit 2)
  (define vk:query-result-with-availability-bit 4)
  (define vk:query-result-partial-bit 8)
  (define vk:query-result-flag-bits-max-enum 2147483647)
  (define-ftype vk:query-result-flags vk:flags)
  (define-ftype vk:buffer-create-flag-bits enum)
  (define vk:buffer-create-sparse-binding-bit 1)
  (define vk:buffer-create-sparse-residency-bit 2)
  (define vk:buffer-create-sparse-aliased-bit 4)
  (define vk:buffer-create-flag-bits-max-enum 2147483647)
  (define-ftype vk:buffer-create-flags vk:flags)
  (define-ftype vk:buffer-usage-flag-bits enum)
  (define vk:buffer-usage-transfer-src-bit 1)
  (define vk:buffer-usage-transfer-dst-bit 2)
  (define vk:buffer-usage-uniform-texel-buffer-bit 4)
  (define vk:buffer-usage-storage-texel-buffer-bit 8)
  (define vk:buffer-usage-uniform-buffer-bit 16)
  (define vk:buffer-usage-storage-buffer-bit 32)
  (define vk:buffer-usage-index-buffer-bit 64)
  (define vk:buffer-usage-vertex-buffer-bit 128)
  (define vk:buffer-usage-indirect-buffer-bit 256)
  (define vk:buffer-usage-flag-bits-max-enum 2147483647)
  (define-ftype vk:buffer-usage-flags vk:flags)
  (define-ftype vk:buffer-view-create-flags vk:flags)
  (define-ftype vk:image-view-create-flags vk:flags)
  (define-ftype vk:shader-module-create-flags vk:flags)
  (define-ftype vk:pipeline-cache-create-flags vk:flags)
  (define-ftype vk:pipeline-create-flag-bits enum)
  (define vk:pipeline-create-disable-optimization-bit 1)
  (define vk:pipeline-create-allow-derivatives-bit 2)
  (define vk:pipeline-create-derivative-bit 4)
  (define vk:pipeline-create-flag-bits-max-enum 2147483647)
  (define-ftype vk:pipeline-create-flags vk:flags)
  (define-ftype vk:pipeline-shader-stage-create-flags
    vk:flags)
  (define-ftype vk:shader-stage-flag-bits enum)
  (define vk:shader-stage-vertex-bit 1)
  (define vk:shader-stage-tessellation-control-bit 2)
  (define vk:shader-stage-tessellation-evaluation-bit 4)
  (define vk:shader-stage-geometry-bit 8)
  (define vk:shader-stage-fragment-bit 16)
  (define vk:shader-stage-compute-bit 32)
  (define vk:shader-stage-all-graphics 31)
  (define vk:shader-stage-all 2147483647)
  (define vk:shader-stage-flag-bits-max-enum 2147483647)
  (define-ftype vk:pipeline-vertex-input-state-create-flags
    vk:flags)
  (define-ftype vk:pipeline-input-assembly-state-create-flags
    vk:flags)
  (define-ftype vk:pipeline-tessellation-state-create-flags
    vk:flags)
  (define-ftype vk:pipeline-viewport-state-create-flags
    vk:flags)
  (define-ftype vk:pipeline-rasterization-state-create-flags
    vk:flags)
  (define-ftype vk:cull-mode-flag-bits enum)
  (define vk:cull-mode-none 0)
  (define vk:cull-mode-front-bit 1)
  (define vk:cull-mode-back-bit 2)
  (define vk:cull-mode-front-and-back 3)
  (define vk:cull-mode-flag-bits-max-enum 2147483647)
  (define-ftype vk:cull-mode-flags vk:flags)
  (define-ftype vk:pipeline-multisample-state-create-flags
    vk:flags)
  (define-ftype vk:pipeline-depth-stencil-state-create-flags
    vk:flags)
  (define-ftype vk:pipeline-color-blend-state-create-flags
    vk:flags)
  (define-ftype vk:color-component-flag-bits enum)
  (define vk:color-component-r-bit 1)
  (define vk:color-component-g-bit 2)
  (define vk:color-component-b-bit 4)
  (define vk:color-component-a-bit 8)
  (define vk:color-component-flag-bits-max-enum 2147483647)
  (define-ftype vk:color-component-flags vk:flags)
  (define-ftype vk:pipeline-dynamic-state-create-flags
    vk:flags)
  (define-ftype vk:pipeline-layout-create-flags vk:flags)
  (define-ftype vk:shader-stage-flags vk:flags)
  (define-ftype vk:sampler-create-flags vk:flags)
  (define-ftype vk:descriptor-set-layout-create-flags
    vk:flags)
  (define-ftype vk:descriptor-pool-create-flag-bits enum)
  (define vk:descriptor-pool-create-free-descriptor-set-bit 1)
  (define vk:descriptor-pool-create-flag-bits-max-enum
    2147483647)
  (define-ftype vk:descriptor-pool-create-flags vk:flags)
  (define-ftype vk:descriptor-pool-reset-flags vk:flags)
  (define-ftype vk:framebuffer-create-flags vk:flags)
  (define-ftype vk:render-pass-create-flags vk:flags)
  (define-ftype vk:attachment-description-flag-bits enum)
  (define vk:attachment-description-may-alias-bit 1)
  (define vk:attachment-description-flag-bits-max-enum
    2147483647)
  (define-ftype vk:attachment-description-flags vk:flags)
  (define-ftype vk:subpass-description-flags vk:flags)
  (define-ftype vk:access-flag-bits enum)
  (define vk:access-indirect-command-read-bit 1)
  (define vk:access-index-read-bit 2)
  (define vk:access-vertex-attribute-read-bit 4)
  (define vk:access-uniform-read-bit 8)
  (define vk:access-input-attachment-read-bit 16)
  (define vk:access-shader-read-bit 32)
  (define vk:access-shader-write-bit 64)
  (define vk:access-color-attachment-read-bit 128)
  (define vk:access-color-attachment-write-bit 256)
  (define vk:access-depth-stencil-attachment-read-bit 512)
  (define vk:access-depth-stencil-attachment-write-bit 1024)
  (define vk:access-transfer-read-bit 2048)
  (define vk:access-transfer-write-bit 4096)
  (define vk:access-host-read-bit 8192)
  (define vk:access-host-write-bit 16384)
  (define vk:access-memory-read-bit 32768)
  (define vk:access-memory-write-bit 65536)
  (define vk:access-flag-bits-max-enum 2147483647)
  (define-ftype vk:access-flags vk:flags)
  (define-ftype vk:dependency-flag-bits enum)
  (define vk:dependency-by-region-bit 1)
  (define vk:dependency-flag-bits-max-enum 2147483647)
  (define-ftype vk:dependency-flags vk:flags)
  (define-ftype vk:command-pool-create-flag-bits enum)
  (define vk:command-pool-create-transient-bit 1)
  (define vk:command-pool-create-reset-command-buffer-bit 2)
  (define vk:command-pool-create-flag-bits-max-enum
    2147483647)
  (define-ftype vk:command-pool-create-flags vk:flags)
  (define-ftype vk:command-pool-reset-flag-bits enum)
  (define vk:command-pool-reset-release-resources-bit 1)
  (define vk:command-pool-reset-flag-bits-max-enum 2147483647)
  (define-ftype vk:command-pool-reset-flags vk:flags)
  (define-ftype vk:command-buffer-usage-flag-bits enum)
  (define vk:command-buffer-usage-one-time-submit-bit 1)
  (define vk:command-buffer-usage-render-pass-continue-bit 2)
  (define vk:command-buffer-usage-simultaneous-use-bit 4)
  (define vk:command-buffer-usage-flag-bits-max-enum
    2147483647)
  (define-ftype vk:command-buffer-usage-flags vk:flags)
  (define-ftype vk:query-control-flag-bits enum)
  (define vk:query-control-precise-bit 1)
  (define vk:query-control-flag-bits-max-enum 2147483647)
  (define-ftype vk:query-control-flags vk:flags)
  (define-ftype vk:command-buffer-reset-flag-bits enum)
  (define vk:command-buffer-reset-release-resources-bit 1)
  (define vk:command-buffer-reset-flag-bits-max-enum
    2147483647)
  (define-ftype vk:command-buffer-reset-flags vk:flags)
  (define-ftype vk:stencil-face-flag-bits enum)
  (define vk:stencil-face-front-bit 1)
  (define vk:stencil-face-back-bit 2)
  (define vk:stencil-front-and-back 3)
  (define vk:stencil-face-flag-bits-max-enum 2147483647)
  (define-ftype vk:stencil-face-flags vk:flags)
  (define-ftype pfn-vk-allocation-function uptr)
  (define-ftype pfn-vk-reallocation-function uptr)
  (define-ftype pfn-vk-free-function uptr)
  (define-ftype pfn-vk-internal-allocation-notification uptr)
  (define-ftype pfn-vk-internal-free-notification uptr)
  (define-ftype pfn-vk-void-function uptr)
  (define-ftype vk:application-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [p-application-name uptr]
      [application-version uint32-t]
      [p-engine-name uptr]
      [engine-version uint32-t]
      [api-version uint32-t]))
  (define-ftype vk:instance-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:instance-create-flags]
      [p-application-info uptr]
      [enabled-layer-count uint32-t]
      [pp-enabled-layer-names uptr]
      [enabled-extension-count uint32-t]
      [pp-enabled-extension-names uptr]))
  (define-ftype vk:allocation-callbacks
    (struct
      [p-user-data uptr]
      [pfn-allocation pfn-vk-allocation-function]
      [pfn-reallocation pfn-vk-reallocation-function]
      [pfn-free pfn-vk-free-function]
      [pfn-internal-allocation pfn-vk-internal-allocation-notification]
      [pfn-internal-free pfn-vk-internal-free-notification]))
  (define-ftype vk:physical-device-features
    (struct
      [robust-buffer-access vk:bool32]
      [full-draw-index-uint32 vk:bool32]
      [image-cube-array vk:bool32]
      [independent-blend vk:bool32]
      [geometry-shader vk:bool32]
      [tessellation-shader vk:bool32]
      [sample-rate-shading vk:bool32]
      [dual-src-blend vk:bool32]
      [logic-op vk:bool32]
      [multi-draw-indirect vk:bool32]
      [draw-indirect-first-instance vk:bool32]
      [depth-clamp vk:bool32]
      [depth-bias-clamp vk:bool32]
      [fill-mode-non-solid vk:bool32]
      [depth-bounds vk:bool32]
      [wide-lines vk:bool32]
      [large-points vk:bool32]
      [alpha-to-one vk:bool32]
      [multi-viewport vk:bool32]
      [sampler-anisotropy vk:bool32]
      [texture-compression-etc2 vk:bool32]
      [texture-compression-astc-ldr vk:bool32]
      [texture-compression-bc vk:bool32]
      [occlusion-query-precise vk:bool32]
      [pipeline-statistics-query vk:bool32]
      [vertex-pipeline-stores-and-atomics vk:bool32]
      [fragment-stores-and-atomics vk:bool32]
      [shader-tessellation-and-geometry-point-size vk:bool32]
      [shader-image-gather-extended vk:bool32]
      [shader-storage-image-extended-formats vk:bool32]
      [shader-storage-image-multisample vk:bool32]
      [shader-storage-image-read-without-format vk:bool32]
      [shader-storage-image-write-without-format vk:bool32]
      [shader-uniform-buffer-array-dynamic-indexing vk:bool32]
      [shader-sampled-image-array-dynamic-indexing vk:bool32]
      [shader-storage-buffer-array-dynamic-indexing vk:bool32]
      [shader-storage-image-array-dynamic-indexing vk:bool32]
      [shader-clip-distance vk:bool32]
      [shader-cull-distance vk:bool32]
      [shader-float64 vk:bool32]
      [shader-int64 vk:bool32]
      [shader-int16 vk:bool32]
      [shader-resource-residency vk:bool32]
      [shader-resource-min-lod vk:bool32]
      [sparse-binding vk:bool32]
      [sparse-residency-buffer vk:bool32]
      [sparse-residency-image2-d vk:bool32]
      [sparse-residency-image3-d vk:bool32]
      [sparse-residency2-samples vk:bool32]
      [sparse-residency4-samples vk:bool32]
      [sparse-residency8-samples vk:bool32]
      [sparse-residency16-samples vk:bool32]
      [sparse-residency-aliased vk:bool32]
      [variable-multisample-rate vk:bool32]
      [inherited-queries vk:bool32]))
  (define-ftype vk:format-properties
    (struct
      [linear-tiling-features vk:format-feature-flags]
      [optimal-tiling-features vk:format-feature-flags]
      [buffer-features vk:format-feature-flags]))
  (define-ftype vk:extent3-d
    (struct
      [width uint32-t]
      [height uint32-t]
      [depth uint32-t]))
  (define-ftype vk:image-format-properties
    (struct
      [max-extent vk:extent3-d]
      [max-mip-levels uint32-t]
      [max-array-layers uint32-t]
      [sample-counts vk:sample-count-flags]
      [max-resource-size vk:device-size]))
  (define-ftype vk:physical-device-limits
    (struct
      [max-image-dimension1-d uint32-t]
      [max-image-dimension2-d uint32-t]
      [max-image-dimension3-d uint32-t]
      [max-image-dimension-cube uint32-t]
      [max-image-array-layers uint32-t]
      [max-texel-buffer-elements uint32-t]
      [max-uniform-buffer-range uint32-t]
      [max-storage-buffer-range uint32-t]
      [max-push-constants-size uint32-t]
      [max-memory-allocation-count uint32-t]
      [max-sampler-allocation-count uint32-t]
      [buffer-image-granularity vk:device-size]
      [sparse-address-space-size vk:device-size]
      [max-bound-descriptor-sets uint32-t]
      [max-per-stage-descriptor-samplers uint32-t]
      [max-per-stage-descriptor-uniform-buffers uint32-t]
      [max-per-stage-descriptor-storage-buffers uint32-t]
      [max-per-stage-descriptor-sampled-images uint32-t]
      [max-per-stage-descriptor-storage-images uint32-t]
      [max-per-stage-descriptor-input-attachments uint32-t]
      [max-per-stage-resources uint32-t]
      [max-descriptor-set-samplers uint32-t]
      [max-descriptor-set-uniform-buffers uint32-t]
      [max-descriptor-set-uniform-buffers-dynamic uint32-t]
      [max-descriptor-set-storage-buffers uint32-t]
      [max-descriptor-set-storage-buffers-dynamic uint32-t]
      [max-descriptor-set-sampled-images uint32-t]
      [max-descriptor-set-storage-images uint32-t]
      [max-descriptor-set-input-attachments uint32-t]
      [max-vertex-input-attributes uint32-t]
      [max-vertex-input-bindings uint32-t]
      [max-vertex-input-attribute-offset uint32-t]
      [max-vertex-input-binding-stride uint32-t]
      [max-vertex-output-components uint32-t]
      [max-tessellation-generation-level uint32-t]
      [max-tessellation-patch-size uint32-t]
      [max-tessellation-control-per-vertex-input-components uint32-t]
      [max-tessellation-control-per-vertex-output-components uint32-t]
      [max-tessellation-control-per-patch-output-components uint32-t]
      [max-tessellation-control-total-output-components uint32-t]
      [max-tessellation-evaluation-input-components uint32-t]
      [max-tessellation-evaluation-output-components uint32-t]
      [max-geometry-shader-invocations uint32-t]
      [max-geometry-input-components uint32-t]
      [max-geometry-output-components uint32-t]
      [max-geometry-output-vertices uint32-t]
      [max-geometry-total-output-components uint32-t]
      [max-fragment-input-components uint32-t]
      [max-fragment-output-attachments uint32-t]
      [max-fragment-dual-src-attachments uint32-t]
      [max-fragment-combined-output-resources uint32-t]
      [max-compute-shared-memory-size uint32-t]
      [max-compute-work-group-count (array 3 uint32-t)]
      [max-compute-work-group-invocations uint32-t]
      [max-compute-work-group-size (array 3 uint32-t)]
      [sub-pixel-precision-bits uint32-t]
      [sub-texel-precision-bits uint32-t]
      [mipmap-precision-bits uint32-t]
      [max-draw-indexed-index-value uint32-t]
      [max-draw-indirect-count uint32-t]
      [max-sampler-lod-bias float]
      [max-sampler-anisotropy float]
      [max-viewports uint32-t]
      [max-viewport-dimensions (array 2 uint32-t)]
      [viewport-bounds-range (array 2 float)]
      [viewport-sub-pixel-bits uint32-t]
      [min-memory-map-alignment size-t]
      [min-texel-buffer-offset-alignment vk:device-size]
      [min-uniform-buffer-offset-alignment vk:device-size]
      [min-storage-buffer-offset-alignment vk:device-size]
      [min-texel-offset int32-t]
      [max-texel-offset uint32-t]
      [min-texel-gather-offset int32-t]
      [max-texel-gather-offset uint32-t]
      [min-interpolation-offset float]
      [max-interpolation-offset float]
      [sub-pixel-interpolation-offset-bits uint32-t]
      [max-framebuffer-width uint32-t]
      [max-framebuffer-height uint32-t]
      [max-framebuffer-layers uint32-t]
      [framebuffer-color-sample-counts vk:sample-count-flags]
      [framebuffer-depth-sample-counts vk:sample-count-flags]
      [framebuffer-stencil-sample-counts vk:sample-count-flags]
      [framebuffer-no-attachments-sample-counts vk:sample-count-flags]
      [max-color-attachments uint32-t]
      [sampled-image-color-sample-counts vk:sample-count-flags]
      [sampled-image-integer-sample-counts vk:sample-count-flags]
      [sampled-image-depth-sample-counts vk:sample-count-flags]
      [sampled-image-stencil-sample-counts vk:sample-count-flags]
      [storage-image-sample-counts vk:sample-count-flags]
      [max-sample-mask-words uint32-t]
      [timestamp-compute-and-graphics vk:bool32]
      [timestamp-period float]
      [max-clip-distances uint32-t]
      [max-cull-distances uint32-t]
      [max-combined-clip-and-cull-distances uint32-t]
      [discrete-queue-priorities uint32-t]
      [point-size-range (array 2 float)]
      [line-width-range (array 2 float)]
      [point-size-granularity float]
      [line-width-granularity float]
      [strict-lines vk:bool32]
      [standard-sample-locations vk:bool32]
      [optimal-buffer-copy-offset-alignment vk:device-size]
      [optimal-buffer-copy-row-pitch-alignment vk:device-size]
      [non-coherent-atom-size vk:device-size]))
  (define-ftype vk:physical-device-sparse-properties
    (struct
      [residency-standard2-dblock-shape vk:bool32]
      [residency-standard2-dmultisample-block-shape vk:bool32]
      [residency-standard3-dblock-shape vk:bool32]
      [residency-aligned-mip-size vk:bool32]
      [residency-non-resident-strict vk:bool32]))
  (define-ftype vk:physical-device-properties
    (struct
      [api-version uint32-t]
      [driver-version uint32-t]
      [vendor-id uint32-t]
      [device-id uint32-t]
      [device-type vk:physical-device-type]
      [device-name (array 256 char)]
      [pipeline-cache-uuid (array 16 uint8-t)]
      [limits vk:physical-device-limits]
      [sparse-properties vk:physical-device-sparse-properties]))
  (define-ftype vk:queue-family-properties
    (struct
      [queue-flags vk:queue-flags]
      [queue-count uint32-t]
      [timestamp-valid-bits uint32-t]
      [min-image-transfer-granularity vk:extent3-d]))
  (define-ftype vk:memory-type
    (struct
      [property-flags vk:memory-property-flags]
      [heap-index uint32-t]))
  (define-ftype vk:memory-heap
    (struct [size vk:device-size] [flags vk:memory-heap-flags]))
  (define-ftype vk:physical-device-memory-properties
    (struct
      [memory-type-count uint32-t]
      [memory-types (array 32 vk:memory-type)]
      [memory-heap-count uint32-t]
      [memory-heaps (array 16 vk:memory-heap)]))
  (define-ftype vk:device-queue-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:device-queue-create-flags]
      [queue-family-index uint32-t]
      [queue-count uint32-t]
      [p-queue-priorities uptr]))
  (define-ftype vk:device-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:device-create-flags]
      [queue-create-info-count uint32-t]
      [p-queue-create-infos uptr]
      [enabled-layer-count uint32-t]
      [pp-enabled-layer-names uptr]
      [enabled-extension-count uint32-t]
      [pp-enabled-extension-names uptr]
      [p-enabled-features uptr]))
  (define-ftype vk:extension-properties
    (struct
      [extension-name (array 256 char)]
      [spec-version uint32-t]))
  (define-ftype vk:layer-properties
    (struct
      [layer-name (array 256 char)]
      [spec-version uint32-t]
      [implementation-version uint32-t]
      [description (array 256 char)]))
  (define-ftype vk:submit-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [wait-semaphore-count uint32-t]
      [p-wait-semaphores uptr]
      [p-wait-dst-stage-mask uptr]
      [command-buffer-count uint32-t]
      [p-command-buffers uptr]
      [signal-semaphore-count uint32-t]
      [p-signal-semaphores uptr]))
  (define-ftype vk:memory-allocate-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [allocation-size vk:device-size]
      [memory-type-index uint32-t]))
  (define-ftype vk:mapped-memory-range
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [memory vk:device-memory]
      [offset vk:device-size]
      [size vk:device-size]))
  (define-ftype vk:memory-requirements
    (struct
      [size vk:device-size]
      [alignment vk:device-size]
      [memory-type-bits uint32-t]))
  (define-ftype vk:sparse-image-format-properties
    (struct
      [aspect-mask vk:image-aspect-flags]
      [image-granularity vk:extent3-d]
      [flags vk:sparse-image-format-flags]))
  (define-ftype vk:sparse-image-memory-requirements
    (struct
      [format-properties vk:sparse-image-format-properties]
      [image-mip-tail-first-lod uint32-t]
      [image-mip-tail-size vk:device-size]
      [image-mip-tail-offset vk:device-size]
      [image-mip-tail-stride vk:device-size]))
  (define-ftype vk:sparse-memory-bind
    (struct
      [resource-offset vk:device-size]
      [size vk:device-size]
      [memory vk:device-memory]
      [memory-offset vk:device-size]
      [flags vk:sparse-memory-bind-flags]))
  (define-ftype vk:sparse-buffer-memory-bind-info
    (struct
      [buffer vk:buffer]
      [bind-count uint32-t]
      [p-binds uptr]))
  (define-ftype vk:sparse-image-opaque-memory-bind-info
    (struct
      [image vk:image]
      [bind-count uint32-t]
      [p-binds uptr]))
  (define-ftype vk:image-subresource
    (struct
      [aspect-mask vk:image-aspect-flags]
      [mip-level uint32-t]
      [array-layer uint32-t]))
  (define-ftype vk:offset3-d
    (struct [x int32-t] [y int32-t] [z int32-t]))
  (define-ftype vk:sparse-image-memory-bind
    (struct
      [subresource vk:image-subresource]
      [offset vk:offset3-d]
      [extent vk:extent3-d]
      [memory vk:device-memory]
      [memory-offset vk:device-size]
      [flags vk:sparse-memory-bind-flags]))
  (define-ftype vk:sparse-image-memory-bind-info
    (struct
      [image vk:image]
      [bind-count uint32-t]
      [p-binds uptr]))
  (define-ftype vk:bind-sparse-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [wait-semaphore-count uint32-t]
      [p-wait-semaphores uptr]
      [buffer-bind-count uint32-t]
      [p-buffer-binds uptr]
      [image-opaque-bind-count uint32-t]
      [p-image-opaque-binds uptr]
      [image-bind-count uint32-t]
      [p-image-binds uptr]
      [signal-semaphore-count uint32-t]
      [p-signal-semaphores uptr]))
  (define-ftype vk:fence-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:fence-create-flags]))
  (define-ftype vk:semaphore-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:semaphore-create-flags]))
  (define-ftype vk:event-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:event-create-flags]))
  (define-ftype vk:query-pool-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:query-pool-create-flags]
      [query-type vk:query-type]
      [query-count uint32-t]
      [pipeline-statistics vk:query-pipeline-statistic-flags]))
  (define-ftype vk:buffer-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:buffer-create-flags]
      [size vk:device-size]
      [usage vk:buffer-usage-flags]
      [sharing-mode vk:sharing-mode]
      [queue-family-index-count uint32-t]
      [p-queue-family-indices uptr]))
  (define-ftype vk:buffer-view-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:buffer-view-create-flags]
      [buffer vk:buffer]
      [format vk:format]
      [offset vk:device-size]
      [range vk:device-size]))
  (define-ftype vk:image-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:image-create-flags]
      [image-type vk:image-type]
      [format vk:format]
      [extent vk:extent3-d]
      [mip-levels uint32-t]
      [array-layers uint32-t]
      [samples vk:sample-count-flag-bits]
      [tiling vk:image-tiling]
      [usage vk:image-usage-flags]
      [sharing-mode vk:sharing-mode]
      [queue-family-index-count uint32-t]
      [p-queue-family-indices uptr]
      [initial-layout vk:image-layout]))
  (define-ftype vk:subresource-layout
    (struct
      [offset vk:device-size]
      [size vk:device-size]
      [row-pitch vk:device-size]
      [array-pitch vk:device-size]
      [depth-pitch vk:device-size]))
  (define-ftype vk:component-mapping
    (struct
      [r vk:component-swizzle]
      [g vk:component-swizzle]
      [b vk:component-swizzle]
      [a vk:component-swizzle]))
  (define-ftype vk:image-subresource-range
    (struct
      [aspect-mask vk:image-aspect-flags]
      [base-mip-level uint32-t]
      [level-count uint32-t]
      [base-array-layer uint32-t]
      [layer-count uint32-t]))
  (define-ftype vk:image-view-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:image-view-create-flags]
      [image vk:image]
      [view-type vk:image-view-type]
      [format vk:format]
      [components vk:component-mapping]
      [subresource-range vk:image-subresource-range]))
  (define-ftype vk:shader-module-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:shader-module-create-flags]
      [code-size size-t]
      [p-code uptr]))
  (define-ftype vk:pipeline-cache-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-cache-create-flags]
      [initial-data-size size-t]
      [p-initial-data uptr]))
  (define-ftype vk:specialization-map-entry
    (struct
      [constant-id uint32-t]
      [offset uint32-t]
      [size size-t]))
  (define-ftype vk:specialization-info
    (struct
      [map-entry-count uint32-t]
      [p-map-entries uptr]
      [data-size size-t]
      [p-data uptr]))
  (define-ftype vk:pipeline-shader-stage-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-shader-stage-create-flags]
      [stage vk:shader-stage-flag-bits]
      [module vk:shader-module]
      [p-name uptr]
      [p-specialization-info uptr]))
  (define-ftype vk:vertex-input-binding-description
    (struct
      [binding uint32-t]
      [stride uint32-t]
      [input-rate vk:vertex-input-rate]))
  (define-ftype vk:vertex-input-attribute-description
    (struct
      [location uint32-t]
      [binding uint32-t]
      [format vk:format]
      [offset uint32-t]))
  (define-ftype vk:pipeline-vertex-input-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-vertex-input-state-create-flags]
      [vertex-binding-description-count uint32-t]
      [p-vertex-binding-descriptions uptr]
      [vertex-attribute-description-count uint32-t]
      [p-vertex-attribute-descriptions uptr]))
  (define-ftype vk:pipeline-input-assembly-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-input-assembly-state-create-flags]
      [topology vk:primitive-topology]
      [primitive-restart-enable vk:bool32]))
  (define-ftype vk:pipeline-tessellation-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-tessellation-state-create-flags]
      [patch-control-points uint32-t]))
  (define-ftype vk:viewport
    (struct
      [x float]
      [y float]
      [width float]
      [height float]
      [min-depth float]
      [max-depth float]))
  (define-ftype vk:offset2-d (struct [x int32-t] [y int32-t]))
  (define-ftype vk:extent2-d
    (struct [width uint32-t] [height uint32-t]))
  (define-ftype vk:rect2-d
    (struct [offset vk:offset2-d] [extent vk:extent2-d]))
  (define-ftype vk:pipeline-viewport-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-viewport-state-create-flags]
      [viewport-count uint32-t]
      [p-viewports uptr]
      [scissor-count uint32-t]
      [p-scissors uptr]))
  (define-ftype vk:pipeline-rasterization-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-rasterization-state-create-flags]
      [depth-clamp-enable vk:bool32]
      [rasterizer-discard-enable vk:bool32]
      [polygon-mode vk:polygon-mode]
      [cull-mode vk:cull-mode-flags]
      [front-face vk:front-face]
      [depth-bias-enable vk:bool32]
      [depth-bias-constant-factor float]
      [depth-bias-clamp float]
      [depth-bias-slope-factor float]
      [line-width float]))
  (define-ftype vk:pipeline-multisample-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-multisample-state-create-flags]
      [rasterization-samples vk:sample-count-flag-bits]
      [sample-shading-enable vk:bool32]
      [min-sample-shading float]
      [p-sample-mask uptr]
      [alpha-to-coverage-enable vk:bool32]
      [alpha-to-one-enable vk:bool32]))
  (define-ftype vk:stencil-op-state
    (struct
      [fail-op vk:stencil-op]
      [pass-op vk:stencil-op]
      [depth-fail-op vk:stencil-op]
      [compare-op vk:compare-op]
      [compare-mask uint32-t]
      [write-mask uint32-t]
      [reference uint32-t]))
  (define-ftype vk:pipeline-depth-stencil-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-depth-stencil-state-create-flags]
      [depth-test-enable vk:bool32]
      [depth-write-enable vk:bool32]
      [depth-compare-op vk:compare-op]
      [depth-bounds-test-enable vk:bool32]
      [stencil-test-enable vk:bool32]
      [front vk:stencil-op-state]
      [back vk:stencil-op-state]
      [min-depth-bounds float]
      [max-depth-bounds float]))
  (define-ftype vk:pipeline-color-blend-attachment-state
    (struct
      [blend-enable vk:bool32]
      [src-color-blend-factor vk:blend-factor]
      [dst-color-blend-factor vk:blend-factor]
      [color-blend-op vk:blend-op]
      [src-alpha-blend-factor vk:blend-factor]
      [dst-alpha-blend-factor vk:blend-factor]
      [alpha-blend-op vk:blend-op]
      [color-write-mask vk:color-component-flags]))
  (define-ftype vk:pipeline-color-blend-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-color-blend-state-create-flags]
      [logic-op-enable vk:bool32]
      [logic-op vk:logic-op]
      [attachment-count uint32-t]
      [p-attachments uptr]
      [blend-constants (array 4 float)]))
  (define-ftype vk:pipeline-dynamic-state-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-dynamic-state-create-flags]
      [dynamic-state-count uint32-t]
      [p-dynamic-states uptr]))
  (define-ftype vk:graphics-pipeline-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-create-flags]
      [stage-count uint32-t]
      [p-stages uptr]
      [p-vertex-input-state uptr]
      [p-input-assembly-state uptr]
      [p-tessellation-state uptr]
      [p-viewport-state uptr]
      [p-rasterization-state uptr]
      [p-multisample-state uptr]
      [p-depth-stencil-state uptr]
      [p-color-blend-state uptr]
      [p-dynamic-state uptr]
      [layout vk:pipeline-layout]
      [render-pass vk:render-pass]
      [subpass uint32-t]
      [base-pipeline-handle vk:pipeline]
      [base-pipeline-index int32-t]))
  (define-ftype vk:compute-pipeline-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-create-flags]
      [stage vk:pipeline-shader-stage-create-info]
      [layout vk:pipeline-layout]
      [base-pipeline-handle vk:pipeline]
      [base-pipeline-index int32-t]))
  (define-ftype vk:push-constant-range
    (struct
      [stage-flags vk:shader-stage-flags]
      [offset uint32-t]
      [size uint32-t]))
  (define-ftype vk:pipeline-layout-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:pipeline-layout-create-flags]
      [set-layout-count uint32-t]
      [p-set-layouts uptr]
      [push-constant-range-count uint32-t]
      [p-push-constant-ranges uptr]))
  (define-ftype vk:sampler-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:sampler-create-flags]
      [mag-filter vk:filter]
      [min-filter vk:filter]
      [mipmap-mode vk:sampler-mipmap-mode]
      [address-mode-u vk:sampler-address-mode]
      [address-mode-v vk:sampler-address-mode]
      [address-mode-w vk:sampler-address-mode]
      [mip-lod-bias float]
      [anisotropy-enable vk:bool32]
      [max-anisotropy float]
      [compare-enable vk:bool32]
      [compare-op vk:compare-op]
      [min-lod float]
      [max-lod float]
      [border-color vk:border-color]
      [unnormalized-coordinates vk:bool32]))
  (define-ftype vk:descriptor-set-layout-binding
    (struct
      [binding uint32-t]
      [descriptor-type vk:descriptor-type]
      [descriptor-count uint32-t]
      [stage-flags vk:shader-stage-flags]
      [p-immutable-samplers uptr]))
  (define-ftype vk:descriptor-set-layout-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:descriptor-set-layout-create-flags]
      [binding-count uint32-t]
      [p-bindings uptr]))
  (define-ftype vk:descriptor-pool-size
    (struct
      [type vk:descriptor-type]
      [descriptor-count uint32-t]))
  (define-ftype vk:descriptor-pool-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:descriptor-pool-create-flags]
      [max-sets uint32-t]
      [pool-size-count uint32-t]
      [p-pool-sizes uptr]))
  (define-ftype vk:descriptor-set-allocate-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [descriptor-pool vk:descriptor-pool]
      [descriptor-set-count uint32-t]
      [p-set-layouts uptr]))
  (define-ftype vk:descriptor-image-info
    (struct
      [sampler vk:sampler]
      [image-view vk:image-view]
      [image-layout vk:image-layout]))
  (define-ftype vk:descriptor-buffer-info
    (struct
      [buffer vk:buffer]
      [offset vk:device-size]
      [range vk:device-size]))
  (define-ftype vk:write-descriptor-set
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [dst-set vk:descriptor-set]
      [dst-binding uint32-t]
      [dst-array-element uint32-t]
      [descriptor-count uint32-t]
      [descriptor-type vk:descriptor-type]
      [p-image-info uptr]
      [p-buffer-info uptr]
      [p-texel-buffer-view uptr]))
  (define-ftype vk:copy-descriptor-set
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [src-set vk:descriptor-set]
      [src-binding uint32-t]
      [src-array-element uint32-t]
      [dst-set vk:descriptor-set]
      [dst-binding uint32-t]
      [dst-array-element uint32-t]
      [descriptor-count uint32-t]))
  (define-ftype vk:framebuffer-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:framebuffer-create-flags]
      [render-pass vk:render-pass]
      [attachment-count uint32-t]
      [p-attachments uptr]
      [width uint32-t]
      [height uint32-t]
      [layers uint32-t]))
  (define-ftype vk:attachment-description
    (struct
      [flags vk:attachment-description-flags]
      [format vk:format]
      [samples vk:sample-count-flag-bits]
      [load-op vk:attachment-load-op]
      [store-op vk:attachment-store-op]
      [stencil-load-op vk:attachment-load-op]
      [stencil-store-op vk:attachment-store-op]
      [initial-layout vk:image-layout]
      [final-layout vk:image-layout]))
  (define-ftype vk:attachment-reference
    (struct [attachment uint32-t] [layout vk:image-layout]))
  (define-ftype vk:subpass-description
    (struct
      [flags vk:subpass-description-flags]
      [pipeline-bind-point vk:pipeline-bind-point]
      [input-attachment-count uint32-t]
      [p-input-attachments uptr]
      [color-attachment-count uint32-t]
      [p-color-attachments uptr]
      [p-resolve-attachments uptr]
      [p-depth-stencil-attachment uptr]
      [preserve-attachment-count uint32-t]
      [p-preserve-attachments uptr]))
  (define-ftype vk:subpass-dependency
    (struct
      [src-subpass uint32-t]
      [dst-subpass uint32-t]
      [src-stage-mask vk:pipeline-stage-flags]
      [dst-stage-mask vk:pipeline-stage-flags]
      [src-access-mask vk:access-flags]
      [dst-access-mask vk:access-flags]
      [dependency-flags vk:dependency-flags]))
  (define-ftype vk:render-pass-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:render-pass-create-flags]
      [attachment-count uint32-t]
      [p-attachments uptr]
      [subpass-count uint32-t]
      [p-subpasses uptr]
      [dependency-count uint32-t]
      [p-dependencies uptr]))
  (define-ftype vk:command-pool-create-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:command-pool-create-flags]
      [queue-family-index uint32-t]))
  (define-ftype vk:command-buffer-allocate-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [command-pool vk:command-pool]
      [level vk:command-buffer-level]
      [command-buffer-count uint32-t]))
  (define-ftype vk:command-buffer-inheritance-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [render-pass vk:render-pass]
      [subpass uint32-t]
      [framebuffer vk:framebuffer]
      [occlusion-query-enable vk:bool32]
      [query-flags vk:query-control-flags]
      [pipeline-statistics vk:query-pipeline-statistic-flags]))
  (define-ftype vk:command-buffer-begin-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:command-buffer-usage-flags]
      [p-inheritance-info uptr]))
  (define-ftype vk:buffer-copy
    (struct
      [src-offset vk:device-size]
      [dst-offset vk:device-size]
      [size vk:device-size]))
  (define-ftype vk:image-subresource-layers
    (struct
      [aspect-mask vk:image-aspect-flags]
      [mip-level uint32-t]
      [base-array-layer uint32-t]
      [layer-count uint32-t]))
  (define-ftype vk:image-copy
    (struct
      [src-subresource vk:image-subresource-layers]
      [src-offset vk:offset3-d]
      [dst-subresource vk:image-subresource-layers]
      [dst-offset vk:offset3-d]
      [extent vk:extent3-d]))
  (define-ftype vk:image-blit
    (struct
      [src-subresource vk:image-subresource-layers]
      [src-offsets (array 2 vk:offset3-d)]
      [dst-subresource vk:image-subresource-layers]
      [dst-offsets (array 2 vk:offset3-d)]))
  (define-ftype vk:buffer-image-copy
    (struct
      [buffer-offset vk:device-size]
      [buffer-row-length uint32-t]
      [buffer-image-height uint32-t]
      [image-subresource vk:image-subresource-layers]
      [image-offset vk:offset3-d]
      [image-extent vk:extent3-d]))
  (define-ftype vk:clear-color-value
    (union
      [float32 (array 4 float)]
      [int32 (array 4 int32-t)]
      [uint32 (array 4 uint32-t)]))
  (define-ftype vk:clear-depth-stencil-value
    (struct [depth float] [stencil uint32-t]))
  (define-ftype vk:clear-value
    (union
      [color vk:clear-color-value]
      [depth-stencil vk:clear-depth-stencil-value]))
  (define-ftype vk:clear-attachment
    (struct
      [aspect-mask vk:image-aspect-flags]
      [color-attachment uint32-t]
      [clear-value vk:clear-value]))
  (define-ftype vk:clear-rect
    (struct
      [rect vk:rect2-d]
      [base-array-layer uint32-t]
      [layer-count uint32-t]))
  (define-ftype vk:image-resolve
    (struct
      [src-subresource vk:image-subresource-layers]
      [src-offset vk:offset3-d]
      [dst-subresource vk:image-subresource-layers]
      [dst-offset vk:offset3-d]
      [extent vk:extent3-d]))
  (define-ftype vk:memory-barrier
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [src-access-mask vk:access-flags]
      [dst-access-mask vk:access-flags]))
  (define-ftype vk:buffer-memory-barrier
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [src-access-mask vk:access-flags]
      [dst-access-mask vk:access-flags]
      [src-queue-family-index uint32-t]
      [dst-queue-family-index uint32-t]
      [buffer vk:buffer]
      [offset vk:device-size]
      [size vk:device-size]))
  (define-ftype vk:image-memory-barrier
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [src-access-mask vk:access-flags]
      [dst-access-mask vk:access-flags]
      [old-layout vk:image-layout]
      [new-layout vk:image-layout]
      [src-queue-family-index uint32-t]
      [dst-queue-family-index uint32-t]
      [image vk:image]
      [subresource-range vk:image-subresource-range]))
  (define-ftype vk:render-pass-begin-info
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [render-pass vk:render-pass]
      [framebuffer vk:framebuffer]
      [render-area vk:rect2-d]
      [clear-value-count uint32-t]
      [p-clear-values uptr]))
  (define-ftype vk:dispatch-indirect-command
    (struct [x uint32-t] [y uint32-t] [z uint32-t]))
  (define-ftype vk:draw-indexed-indirect-command
    (struct
      [index-count uint32-t]
      [instance-count uint32-t]
      [first-index uint32-t]
      [vertex-offset int32-t]
      [first-instance uint32-t]))
  (define-ftype vk:draw-indirect-command
    (struct
      [vertex-count uint32-t]
      [instance-count uint32-t]
      [first-vertex uint32-t]
      [first-instance uint32-t]))
  (define-ftype pfn-vk-create-instance uptr)
  (define-ftype pfn-vk-destroy-instance uptr)
  (define-ftype pfn-vk-enumerate-physical-devices uptr)
  (define-ftype pfn-vk-get-physical-device-features uptr)
  (define-ftype pfn-vk-get-physical-device-format-properties
    uptr)
  (define-ftype pfn-vk-get-physical-device-image-format-properties
    uptr)
  (define-ftype pfn-vk-get-physical-device-properties uptr)
  (define-ftype pfn-vk-get-physical-device-queue-family-properties
    uptr)
  (define-ftype pfn-vk-get-physical-device-memory-properties
    uptr)
  (define-ftype pfn-vk-get-instance-proc-addr uptr)
  (define-ftype pfn-vk-get-device-proc-addr uptr)
  (define-ftype pfn-vk-create-device uptr)
  (define-ftype pfn-vk-destroy-device uptr)
  (define-ftype pfn-vk-enumerate-instance-extension-properties
    uptr)
  (define-ftype pfn-vk-enumerate-device-extension-properties
    uptr)
  (define-ftype pfn-vk-enumerate-instance-layer-properties
    uptr)
  (define-ftype pfn-vk-enumerate-device-layer-properties uptr)
  (define-ftype pfn-vk-get-device-queue uptr)
  (define-ftype pfn-vk-queue-submit uptr)
  (define-ftype pfn-vk-queue-wait-idle uptr)
  (define-ftype pfn-vk-device-wait-idle uptr)
  (define-ftype pfn-vk-allocate-memory uptr)
  (define-ftype pfn-vk-free-memory uptr)
  (define-ftype pfn-vk-map-memory uptr)
  (define-ftype pfn-vk-unmap-memory uptr)
  (define-ftype pfn-vk-flush-mapped-memory-ranges uptr)
  (define-ftype pfn-vk-invalidate-mapped-memory-ranges uptr)
  (define-ftype pfn-vk-get-device-memory-commitment uptr)
  (define-ftype pfn-vk-bind-buffer-memory uptr)
  (define-ftype pfn-vk-bind-image-memory uptr)
  (define-ftype pfn-vk-get-buffer-memory-requirements uptr)
  (define-ftype pfn-vk-get-image-memory-requirements uptr)
  (define-ftype pfn-vk-get-image-sparse-memory-requirements
    uptr)
  (define-ftype pfn-vk-get-physical-device-sparse-image-format-properties
    uptr)
  (define-ftype pfn-vk-queue-bind-sparse uptr)
  (define-ftype pfn-vk-create-fence uptr)
  (define-ftype pfn-vk-destroy-fence uptr)
  (define-ftype pfn-vk-reset-fences uptr)
  (define-ftype pfn-vk-get-fence-status uptr)
  (define-ftype pfn-vk-wait-for-fences uptr)
  (define-ftype pfn-vk-create-semaphore uptr)
  (define-ftype pfn-vk-destroy-semaphore uptr)
  (define-ftype pfn-vk-create-event uptr)
  (define-ftype pfn-vk-destroy-event uptr)
  (define-ftype pfn-vk-get-event-status uptr)
  (define-ftype pfn-vk-set-event uptr)
  (define-ftype pfn-vk-reset-event uptr)
  (define-ftype pfn-vk-create-query-pool uptr)
  (define-ftype pfn-vk-destroy-query-pool uptr)
  (define-ftype pfn-vk-get-query-pool-results uptr)
  (define-ftype pfn-vk-create-buffer uptr)
  (define-ftype pfn-vk-destroy-buffer uptr)
  (define-ftype pfn-vk-create-buffer-view uptr)
  (define-ftype pfn-vk-destroy-buffer-view uptr)
  (define-ftype pfn-vk-create-image uptr)
  (define-ftype pfn-vk-destroy-image uptr)
  (define-ftype pfn-vk-get-image-subresource-layout uptr)
  (define-ftype pfn-vk-create-image-view uptr)
  (define-ftype pfn-vk-destroy-image-view uptr)
  (define-ftype pfn-vk-create-shader-module uptr)
  (define-ftype pfn-vk-destroy-shader-module uptr)
  (define-ftype pfn-vk-create-pipeline-cache uptr)
  (define-ftype pfn-vk-destroy-pipeline-cache uptr)
  (define-ftype pfn-vk-get-pipeline-cache-data uptr)
  (define-ftype pfn-vk-merge-pipeline-caches uptr)
  (define-ftype pfn-vk-create-graphics-pipelines uptr)
  (define-ftype pfn-vk-create-compute-pipelines uptr)
  (define-ftype pfn-vk-destroy-pipeline uptr)
  (define-ftype pfn-vk-create-pipeline-layout uptr)
  (define-ftype pfn-vk-destroy-pipeline-layout uptr)
  (define-ftype pfn-vk-create-sampler uptr)
  (define-ftype pfn-vk-destroy-sampler uptr)
  (define-ftype pfn-vk-create-descriptor-set-layout uptr)
  (define-ftype pfn-vk-destroy-descriptor-set-layout uptr)
  (define-ftype pfn-vk-create-descriptor-pool uptr)
  (define-ftype pfn-vk-destroy-descriptor-pool uptr)
  (define-ftype pfn-vk-reset-descriptor-pool uptr)
  (define-ftype pfn-vk-allocate-descriptor-sets uptr)
  (define-ftype pfn-vk-free-descriptor-sets uptr)
  (define-ftype pfn-vk-update-descriptor-sets uptr)
  (define-ftype pfn-vk-create-framebuffer uptr)
  (define-ftype pfn-vk-destroy-framebuffer uptr)
  (define-ftype pfn-vk-create-render-pass uptr)
  (define-ftype pfn-vk-destroy-render-pass uptr)
  (define-ftype pfn-vk-get-render-area-granularity uptr)
  (define-ftype pfn-vk-create-command-pool uptr)
  (define-ftype pfn-vk-destroy-command-pool uptr)
  (define-ftype pfn-vk-reset-command-pool uptr)
  (define-ftype pfn-vk-allocate-command-buffers uptr)
  (define-ftype pfn-vk-free-command-buffers uptr)
  (define-ftype pfn-vk-begin-command-buffer uptr)
  (define-ftype pfn-vk-end-command-buffer uptr)
  (define-ftype pfn-vk-reset-command-buffer uptr)
  (define-ftype pfn-vk-cmd-bind-pipeline uptr)
  (define-ftype pfn-vk-cmd-set-viewport uptr)
  (define-ftype pfn-vk-cmd-set-scissor uptr)
  (define-ftype pfn-vk-cmd-set-line-width uptr)
  (define-ftype pfn-vk-cmd-set-depth-bias uptr)
  (define-ftype pfn-vk-cmd-set-blend-constants uptr)
  (define-ftype pfn-vk-cmd-set-depth-bounds uptr)
  (define-ftype pfn-vk-cmd-set-stencil-compare-mask uptr)
  (define-ftype pfn-vk-cmd-set-stencil-write-mask uptr)
  (define-ftype pfn-vk-cmd-set-stencil-reference uptr)
  (define-ftype pfn-vk-cmd-bind-descriptor-sets uptr)
  (define-ftype pfn-vk-cmd-bind-index-buffer uptr)
  (define-ftype pfn-vk-cmd-bind-vertex-buffers uptr)
  (define-ftype pfn-vk-cmd-draw uptr)
  (define-ftype pfn-vk-cmd-draw-indexed uptr)
  (define-ftype pfn-vk-cmd-draw-indirect uptr)
  (define-ftype pfn-vk-cmd-draw-indexed-indirect uptr)
  (define-ftype pfn-vk-cmd-dispatch uptr)
  (define-ftype pfn-vk-cmd-dispatch-indirect uptr)
  (define-ftype pfn-vk-cmd-copy-buffer uptr)
  (define-ftype pfn-vk-cmd-copy-image uptr)
  (define-ftype pfn-vk-cmd-blit-image uptr)
  (define-ftype pfn-vk-cmd-copy-buffer-to-image uptr)
  (define-ftype pfn-vk-cmd-copy-image-to-buffer uptr)
  (define-ftype pfn-vk-cmd-update-buffer uptr)
  (define-ftype pfn-vk-cmd-fill-buffer uptr)
  (define-ftype pfn-vk-cmd-clear-color-image uptr)
  (define-ftype pfn-vk-cmd-clear-depth-stencil-image uptr)
  (define-ftype pfn-vk-cmd-clear-attachments uptr)
  (define-ftype pfn-vk-cmd-resolve-image uptr)
  (define-ftype pfn-vk-cmd-set-event uptr)
  (define-ftype pfn-vk-cmd-reset-event uptr)
  (define-ftype pfn-vk-cmd-wait-events uptr)
  (define-ftype pfn-vk-cmd-pipeline-barrier uptr)
  (define-ftype pfn-vk-cmd-begin-query uptr)
  (define-ftype pfn-vk-cmd-end-query uptr)
  (define-ftype pfn-vk-cmd-reset-query-pool uptr)
  (define-ftype pfn-vk-cmd-write-timestamp uptr)
  (define-ftype pfn-vk-cmd-copy-query-pool-results uptr)
  (define-ftype pfn-vk-cmd-push-constants uptr)
  (define-ftype pfn-vk-cmd-begin-render-pass uptr)
  (define-ftype pfn-vk-cmd-next-subpass uptr)
  (define-ftype pfn-vk-cmd-end-render-pass uptr)
  (define-ftype pfn-vk-cmd-execute-commands uptr)
  (define-ftype vk:surface-khr uptr)
  (define-ftype vk:color-space-khr enum)
  (define vk:color-space-srgb-nonlinear-khr 0)
  (define vk:color-space-begin-range-khr 0)
  (define vk:color-space-end-range-khr 0)
  (define vk:color-space-range-size-khr 1)
  (define vk:color-space-max-enum-khr 2147483647)
  (define-ftype vk:present-mode-khr enum)
  (define vk:present-mode-immediate-khr 0)
  (define vk:present-mode-mailbox-khr 1)
  (define vk:present-mode-fifo-khr 2)
  (define vk:present-mode-fifo-relaxed-khr 3)
  (define vk:present-mode-begin-range-khr 0)
  (define vk:present-mode-end-range-khr 3)
  (define vk:present-mode-range-size-khr 4)
  (define vk:present-mode-max-enum-khr 2147483647)
  (define-ftype vk:surface-transform-flag-bits-khr enum)
  (define vk:surface-transform-identity-bit-khr 1)
  (define vk:surface-transform-rotate-90-bit-khr 2)
  (define vk:surface-transform-rotate-180-bit-khr 4)
  (define vk:surface-transform-rotate-270-bit-khr 8)
  (define vk:surface-transform-horizontal-mirror-bit-khr 16)
  (define vk:surface-transform-horizontal-mirror-rotate-90-bit-khr
    32)
  (define vk:surface-transform-horizontal-mirror-rotate-180-bit-khr
    64)
  (define vk:surface-transform-horizontal-mirror-rotate-270-bit-khr
    128)
  (define vk:surface-transform-inherit-bit-khr 256)
  (define vk:surface-transform-flag-bits-max-enum-khr
    2147483647)
  (define-ftype vk:surface-transform-flags-khr vk:flags)
  (define-ftype vk:composite-alpha-flag-bits-khr enum)
  (define vk:composite-alpha-opaque-bit-khr 1)
  (define vk:composite-alpha-pre-multiplied-bit-khr 2)
  (define vk:composite-alpha-post-multiplied-bit-khr 4)
  (define vk:composite-alpha-inherit-bit-khr 8)
  (define vk:composite-alpha-flag-bits-max-enum-khr
    2147483647)
  (define-ftype vk:composite-alpha-flags-khr vk:flags)
  (define-ftype vk:surface-capabilities-khr
    (struct
      [min-image-count uint32-t]
      [max-image-count uint32-t]
      [current-extent vk:extent2-d]
      [min-image-extent vk:extent2-d]
      [max-image-extent vk:extent2-d]
      [max-image-array-layers uint32-t]
      [supported-transforms vk:surface-transform-flags-khr]
      [current-transform vk:surface-transform-flag-bits-khr]
      [supported-composite-alpha vk:composite-alpha-flags-khr]
      [supported-usage-flags vk:image-usage-flags]))
  (define-ftype vk:surface-format-khr
    (struct
      [format vk:format]
      [color-space vk:color-space-khr]))
  (define-ftype pfn-vk-destroy-surface-khr uptr)
  (define-ftype pfn-vk-get-physical-device-surface-support-khr
    uptr)
  (define-ftype pfn-vk-get-physical-device-surface-capabilities-khr
    uptr)
  (define-ftype pfn-vk-get-physical-device-surface-formats-khr
    uptr)
  (define-ftype pfn-vk-get-physical-device-surface-present-modes-khr
    uptr)
  (define-ftype vk:swapchain-khr uptr)
  (define-ftype vk:swapchain-create-flags-khr vk:flags)
  (define-ftype vk:swapchain-create-info-khr
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:swapchain-create-flags-khr]
      [surface vk:surface-khr]
      [min-image-count uint32-t]
      [image-format vk:format]
      [image-color-space vk:color-space-khr]
      [image-extent vk:extent2-d]
      [image-array-layers uint32-t]
      [image-usage vk:image-usage-flags]
      [image-sharing-mode vk:sharing-mode]
      [queue-family-index-count uint32-t]
      [p-queue-family-indices uptr]
      [pre-transform vk:surface-transform-flag-bits-khr]
      [composite-alpha vk:composite-alpha-flag-bits-khr]
      [present-mode vk:present-mode-khr]
      [clipped vk:bool32]
      [old-swapchain vk:swapchain-khr]))
  (define-ftype vk:present-info-khr
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [wait-semaphore-count uint32-t]
      [p-wait-semaphores uptr]
      [swapchain-count uint32-t]
      [p-swapchains uptr]
      [p-image-indices uptr]
      [p-results uptr]))
  (define-ftype pfn-vk-create-swapchain-khr uptr)
  (define-ftype pfn-vk-destroy-swapchain-khr uptr)
  (define-ftype pfn-vk-get-swapchain-images-khr uptr)
  (define-ftype pfn-vk-acquire-next-image-khr uptr)
  (define-ftype pfn-vk-queue-present-khr uptr)
  (define-ftype vk:display-khr uptr)
  (define-ftype vk:display-mode-khr uptr)
  (define-ftype vk:display-plane-alpha-flag-bits-khr enum)
  (define vk:display-plane-alpha-opaque-bit-khr 1)
  (define vk:display-plane-alpha-global-bit-khr 2)
  (define vk:display-plane-alpha-per-pixel-bit-khr 4)
  (define vk:display-plane-alpha-per-pixel-premultiplied-bit-khr
    8)
  (define vk:display-plane-alpha-flag-bits-max-enum-khr
    2147483647)
  (define-ftype vk:display-plane-alpha-flags-khr vk:flags)
  (define-ftype vk:display-mode-create-flags-khr vk:flags)
  (define-ftype vk:display-surface-create-flags-khr vk:flags)
  (define-ftype vk:display-properties-khr
    (struct
      [display vk:display-khr]
      [display-name uptr]
      [physical-dimensions vk:extent2-d]
      [physical-resolution vk:extent2-d]
      [supported-transforms vk:surface-transform-flags-khr]
      [plane-reorder-possible vk:bool32]
      [persistent-content vk:bool32]))
  (define-ftype vk:display-mode-parameters-khr
    (struct
      [visible-region vk:extent2-d]
      [refresh-rate uint32-t]))
  (define-ftype vk:display-mode-properties-khr
    (struct
      [display-mode vk:display-mode-khr]
      [parameters vk:display-mode-parameters-khr]))
  (define-ftype vk:display-mode-create-info-khr
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:display-mode-create-flags-khr]
      [parameters vk:display-mode-parameters-khr]))
  (define-ftype vk:display-plane-capabilities-khr
    (struct
      [supported-alpha vk:display-plane-alpha-flags-khr]
      [min-src-position vk:offset2-d]
      [max-src-position vk:offset2-d]
      [min-src-extent vk:extent2-d]
      [max-src-extent vk:extent2-d]
      [min-dst-position vk:offset2-d]
      [max-dst-position vk:offset2-d]
      [min-dst-extent vk:extent2-d]
      [max-dst-extent vk:extent2-d]))
  (define-ftype vk:display-plane-properties-khr
    (struct
      [current-display vk:display-khr]
      [current-stack-index uint32-t]))
  (define-ftype vk:display-surface-create-info-khr
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:display-surface-create-flags-khr]
      [display-mode vk:display-mode-khr]
      [plane-index uint32-t]
      [plane-stack-index uint32-t]
      [transform vk:surface-transform-flag-bits-khr]
      [global-alpha float]
      [alpha-mode vk:display-plane-alpha-flag-bits-khr]
      [image-extent vk:extent2-d]))
  (define-ftype pfn-vk-get-physical-device-display-properties-khr
    uptr)
  (define-ftype pfn-vk-get-physical-device-display-plane-properties-khr
    uptr)
  (define-ftype pfn-vk-get-display-plane-supported-displays-khr
    uptr)
  (define-ftype pfn-vk-get-display-mode-properties-khr uptr)
  (define-ftype pfn-vk-create-display-mode-khr uptr)
  (define-ftype pfn-vk-get-display-plane-capabilities-khr
    uptr)
  (define-ftype pfn-vk-create-display-plane-surface-khr uptr)
  (define-ftype vk:display-present-info-khr
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [src-rect vk:rect2-d]
      [dst-rect vk:rect2-d]
      [persistent vk:bool32]))
  (define-ftype pfn-vk-create-shared-swapchains-khr uptr)
  (define-ftype vk:debug-report-callback-ext uptr)
  (define-ftype vk:debug-report-object-type-ext enum)
  (define vk:debug-report-object-type-unknown-ext 0)
  (define vk:debug-report-object-type-instance-ext 1)
  (define vk:debug-report-object-type-physical-device-ext 2)
  (define vk:debug-report-object-type-device-ext 3)
  (define vk:debug-report-object-type-queue-ext 4)
  (define vk:debug-report-object-type-semaphore-ext 5)
  (define vk:debug-report-object-type-command-buffer-ext 6)
  (define vk:debug-report-object-type-fence-ext 7)
  (define vk:debug-report-object-type-device-memory-ext 8)
  (define vk:debug-report-object-type-buffer-ext 9)
  (define vk:debug-report-object-type-image-ext 10)
  (define vk:debug-report-object-type-event-ext 11)
  (define vk:debug-report-object-type-query-pool-ext 12)
  (define vk:debug-report-object-type-buffer-view-ext 13)
  (define vk:debug-report-object-type-image-view-ext 14)
  (define vk:debug-report-object-type-shader-module-ext 15)
  (define vk:debug-report-object-type-pipeline-cache-ext 16)
  (define vk:debug-report-object-type-pipeline-layout-ext 17)
  (define vk:debug-report-object-type-render-pass-ext 18)
  (define vk:debug-report-object-type-pipeline-ext 19)
  (define vk:debug-report-object-type-descriptor-set-layout-ext
    20)
  (define vk:debug-report-object-type-sampler-ext 21)
  (define vk:debug-report-object-type-descriptor-pool-ext 22)
  (define vk:debug-report-object-type-descriptor-set-ext 23)
  (define vk:debug-report-object-type-framebuffer-ext 24)
  (define vk:debug-report-object-type-command-pool-ext 25)
  (define vk:debug-report-object-type-surface-khr-ext 26)
  (define vk:debug-report-object-type-swapchain-khr-ext 27)
  (define vk:debug-report-object-type-debug-report-ext 28)
  (define vk:debug-report-object-type-begin-range-ext 0)
  (define vk:debug-report-object-type-end-range-ext 28)
  (define vk:debug-report-object-type-range-size-ext 29)
  (define vk:debug-report-object-type-max-enum-ext 2147483647)
  (define-ftype vk:debug-report-error-ext enum)
  (define vk:debug-report-error-none-ext 0)
  (define vk:debug-report-error-callback-ref-ext 1)
  (define vk:debug-report-error-begin-range-ext 0)
  (define vk:debug-report-error-end-range-ext 1)
  (define vk:debug-report-error-range-size-ext 2)
  (define vk:debug-report-error-max-enum-ext 2147483647)
  (define-ftype vk:debug-report-flag-bits-ext enum)
  (define vk:debug-report-information-bit-ext 1)
  (define vk:debug-report-warning-bit-ext 2)
  (define vk:debug-report-performance-warning-bit-ext 4)
  (define vk:debug-report-error-bit-ext 8)
  (define vk:debug-report-debug-bit-ext 16)
  (define vk:debug-report-flag-bits-max-enum-ext 2147483647)
  (define-ftype vk:debug-report-flags-ext vk:flags)
  (define-ftype pfn-vk-debug-report-callback-ext uptr)
  (define-ftype vk:debug-report-callback-create-info-ext
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [flags vk:debug-report-flags-ext]
      [pfn-callback pfn-vk-debug-report-callback-ext]
      [p-user-data uptr]))
  (define-ftype pfn-vk-create-debug-report-callback-ext uptr)
  (define-ftype pfn-vk-destroy-debug-report-callback-ext uptr)
  (define-ftype pfn-vk-debug-report-message-ext uptr)
  (define-ftype vk:rasterization-order-amd enum)
  (define vk:rasterization-order-strict-amd 0)
  (define vk:rasterization-order-relaxed-amd 1)
  (define vk:rasterization-order-begin-range-amd 0)
  (define vk:rasterization-order-end-range-amd 1)
  (define vk:rasterization-order-range-size-amd 2)
  (define vk:rasterization-order-max-enum-amd 2147483647)
  (define-ftype vk:pipeline-rasterization-state-rasterization-order-amd
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [rasterization-order vk:rasterization-order-amd]))
  (define-ftype vk:debug-marker-object-name-info-ext
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [object-type vk:debug-report-object-type-ext]
      [object uint64-t]
      [p-object-name uptr]))
  (define-ftype vk:debug-marker-object-tag-info-ext
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [object-type vk:debug-report-object-type-ext]
      [object uint64-t]
      [tag-name uint64-t]
      [tag-size size-t]
      [p-tag uptr]))
  (define-ftype vk:debug-marker-marker-info-ext
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [p-marker-name uptr]
      [color (array 4 float)]))
  (define-ftype pfn-vk-debug-marker-set-object-tag-ext uptr)
  (define-ftype pfn-vk-debug-marker-set-object-name-ext uptr)
  (define-ftype pfn-vk-cmd-debug-marker-begin-ext uptr)
  (define-ftype pfn-vk-cmd-debug-marker-end-ext uptr)
  (define-ftype pfn-vk-cmd-debug-marker-insert-ext uptr)
  (define-ftype vk:dedicated-allocation-image-create-info-nv
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [dedicated-allocation vk:bool32]))
  (define-ftype vk:dedicated-allocation-buffer-create-info-nv
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [dedicated-allocation vk:bool32]))
  (define-ftype vk:dedicated-allocation-memory-allocate-info-nv
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [image vk:image]
      [buffer vk:buffer]))
  (define-ftype pfn-vk-cmd-draw-indirect-count-amd uptr)
  (define-ftype pfn-vk-cmd-draw-indexed-indirect-count-amd
    uptr)
  (define-ftype vk:external-memory-handle-type-flag-bits-nv
    enum)
  (define vk:external-memory-handle-type-opaque-win32-bit-nv
    1)
  (define vk:external-memory-handle-type-opaque-win32-kmt-bit-nv
    2)
  (define vk:external-memory-handle-type-d3d11-image-bit-nv 4)
  (define vk:external-memory-handle-type-d3d11-image-kmt-bit-nv
    8)
  (define vk:external-memory-handle-type-flag-bits-max-enum-nv
    2147483647)
  (define-ftype vk:external-memory-handle-type-flags-nv
    vk:flags)
  (define-ftype vk:external-memory-feature-flag-bits-nv enum)
  (define vk:external-memory-feature-dedicated-only-bit-nv 1)
  (define vk:external-memory-feature-exportable-bit-nv 2)
  (define vk:external-memory-feature-importable-bit-nv 4)
  (define vk:external-memory-feature-flag-bits-max-enum-nv
    2147483647)
  (define-ftype vk:external-memory-feature-flags-nv vk:flags)
  (define-ftype vk:external-image-format-properties-nv
    (struct
      [image-format-properties vk:image-format-properties]
      [external-memory-features vk:external-memory-feature-flags-nv]
      [export-from-imported-handle-types vk:external-memory-handle-type-flags-nv]
      [compatible-handle-types vk:external-memory-handle-type-flags-nv]))
  (define-ftype pfn-vk-get-physical-device-external-image-format-properties-nv
    uptr)
  (define-ftype vk:external-memory-image-create-info-nv
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [handle-types vk:external-memory-handle-type-flags-nv]))
  (define-ftype vk:export-memory-allocate-info-nv
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [handle-types vk:external-memory-handle-type-flags-nv]))
  (define-ftype vk:validation-check-ext enum)
  (define vk:validation-check-all-ext 0)
  (define vk:validation-check-begin-range-ext 0)
  (define vk:validation-check-end-range-ext 0)
  (define vk:validation-check-range-size-ext 1)
  (define vk:validation-check-max-enum-ext 2147483647)
  (define-ftype vk:validation-flags-ext
    (struct
      [s-type vk:structure-type]
      [p-next uptr]
      [disabled-validation-check-count uint32-t]
      [p-disabled-validation-checks uptr]))
  (define vk:create-instance
    (foreign-procedure "vkCreateInstance"
      (uptr uptr uptr)
      vk:result))
  (define vk:destroy-instance
    (foreign-procedure "vkDestroyInstance"
      (vk:instance uptr)
      void))
  (define vk:enumerate-physical-devices
    (foreign-procedure "vkEnumeratePhysicalDevices"
      (vk:instance uptr uptr)
      vk:result))
  (define vk:get-physical-device-features
    (foreign-procedure "vkGetPhysicalDeviceFeatures"
      (vk:physical-device uptr)
      void))
  (define vk:get-physical-device-format-properties
    (foreign-procedure "vkGetPhysicalDeviceFormatProperties"
      (vk:physical-device vk:format uptr)
      void))
  (define vk:get-physical-device-image-format-properties
    (foreign-procedure "vkGetPhysicalDeviceImageFormatProperties"
      (vk:physical-device
       vk:format
       vk:image-type
       vk:image-tiling
       vk:image-usage-flags
       vk:image-create-flags
       uptr)
      vk:result))
  (define vk:get-physical-device-properties
    (foreign-procedure "vkGetPhysicalDeviceProperties"
      (vk:physical-device uptr)
      void))
  (define vk:get-physical-device-queue-family-properties
    (foreign-procedure "vkGetPhysicalDeviceQueueFamilyProperties"
      (vk:physical-device uptr uptr)
      void))
  (define vk:get-physical-device-memory-properties
    (foreign-procedure "vkGetPhysicalDeviceMemoryProperties"
      (vk:physical-device uptr)
      void))
  (define vk:get-instance-proc-addr
    (foreign-procedure "vkGetInstanceProcAddr"
      (vk:instance uptr)
      pfn-vk-void-function))
  (define vk:get-device-proc-addr
    (foreign-procedure "vkGetDeviceProcAddr"
      (vk:device uptr)
      pfn-vk-void-function))
  (define vk:create-device
    (foreign-procedure "vkCreateDevice"
      (vk:physical-device uptr uptr uptr)
      vk:result))
  (define vk:destroy-device
    (foreign-procedure "vkDestroyDevice" (vk:device uptr) void))
  (define vk:enumerate-instance-extension-properties
    (foreign-procedure "vkEnumerateInstanceExtensionProperties"
      (uptr uptr uptr)
      vk:result))
  (define vk:enumerate-device-extension-properties
    (foreign-procedure "vkEnumerateDeviceExtensionProperties"
      (vk:physical-device uptr uptr uptr)
      vk:result))
  (define vk:enumerate-instance-layer-properties
    (foreign-procedure "vkEnumerateInstanceLayerProperties"
      (uptr uptr)
      vk:result))
  (define vk:enumerate-device-layer-properties
    (foreign-procedure "vkEnumerateDeviceLayerProperties"
      (vk:physical-device uptr uptr)
      vk:result))
  (define vk:get-device-queue
    (foreign-procedure "vkGetDeviceQueue"
      (vk:device uint32-t uint32-t uptr)
      void))
  (define vk:queue-submit
    (foreign-procedure "vkQueueSubmit"
      (vk:queue uint32-t uptr vk:fence)
      vk:result))
  (define vk:queue-wait-idle
    (foreign-procedure "vkQueueWaitIdle" (vk:queue) vk:result))
  (define vk:device-wait-idle
    (foreign-procedure "vkDeviceWaitIdle"
      (vk:device)
      vk:result))
  (define vk:allocate-memory
    (foreign-procedure "vkAllocateMemory"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:free-memory
    (foreign-procedure "vkFreeMemory"
      (vk:device vk:device-memory uptr)
      void))
  (define vk:map-memory
    (foreign-procedure "vkMapMemory"
      (vk:device
       vk:device-memory
       vk:device-size
       vk:device-size
       vk:memory-map-flags
       uptr)
      vk:result))
  (define vk:unmap-memory
    (foreign-procedure "vkUnmapMemory"
      (vk:device vk:device-memory)
      void))
  (define vk:flush-mapped-memory-ranges
    (foreign-procedure "vkFlushMappedMemoryRanges"
      (vk:device uint32-t uptr)
      vk:result))
  (define vk:invalidate-mapped-memory-ranges
    (foreign-procedure "vkInvalidateMappedMemoryRanges"
      (vk:device uint32-t uptr)
      vk:result))
  (define vk:get-device-memory-commitment
    (foreign-procedure "vkGetDeviceMemoryCommitment"
      (vk:device vk:device-memory uptr)
      void))
  (define vk:bind-buffer-memory
    (foreign-procedure "vkBindBufferMemory"
      (vk:device vk:buffer vk:device-memory vk:device-size)
      vk:result))
  (define vk:bind-image-memory
    (foreign-procedure "vkBindImageMemory"
      (vk:device vk:image vk:device-memory vk:device-size)
      vk:result))
  (define vk:get-buffer-memory-requirements
    (foreign-procedure "vkGetBufferMemoryRequirements"
      (vk:device vk:buffer uptr)
      void))
  (define vk:get-image-memory-requirements
    (foreign-procedure "vkGetImageMemoryRequirements"
      (vk:device vk:image uptr)
      void))
  (define vk:get-image-sparse-memory-requirements
    (foreign-procedure "vkGetImageSparseMemoryRequirements"
      (vk:device vk:image uptr uptr)
      void))
  (define vk:get-physical-device-sparse-image-format-properties
    (foreign-procedure "vkGetPhysicalDeviceSparseImageFormatProperties"
      (vk:physical-device
       vk:format
       vk:image-type
       vk:sample-count-flag-bits
       vk:image-usage-flags
       vk:image-tiling
       uptr
       uptr)
      void))
  (define vk:queue-bind-sparse
    (foreign-procedure "vkQueueBindSparse"
      (vk:queue uint32-t uptr vk:fence)
      vk:result))
  (define vk:create-fence
    (foreign-procedure "vkCreateFence"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-fence
    (foreign-procedure "vkDestroyFence"
      (vk:device vk:fence uptr)
      void))
  (define vk:reset-fences
    (foreign-procedure "vkResetFences"
      (vk:device uint32-t uptr)
      vk:result))
  (define vk:get-fence-status
    (foreign-procedure "vkGetFenceStatus"
      (vk:device vk:fence)
      vk:result))
  (define vk:wait-for-fences
    (foreign-procedure "vkWaitForFences"
      (vk:device uint32-t uptr vk:bool32 uint64-t)
      vk:result))
  (define vk:create-semaphore
    (foreign-procedure "vkCreateSemaphore"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-semaphore
    (foreign-procedure "vkDestroySemaphore"
      (vk:device vk:semaphore uptr)
      void))
  (define vk:create-event
    (foreign-procedure "vkCreateEvent"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-event
    (foreign-procedure "vkDestroyEvent"
      (vk:device vk:event uptr)
      void))
  (define vk:get-event-status
    (foreign-procedure "vkGetEventStatus"
      (vk:device vk:event)
      vk:result))
  (define vk:set-event
    (foreign-procedure "vkSetEvent"
      (vk:device vk:event)
      vk:result))
  (define vk:reset-event
    (foreign-procedure "vkResetEvent"
      (vk:device vk:event)
      vk:result))
  (define vk:create-query-pool
    (foreign-procedure "vkCreateQueryPool"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-query-pool
    (foreign-procedure "vkDestroyQueryPool"
      (vk:device vk:query-pool uptr)
      void))
  (define vk:get-query-pool-results
    (foreign-procedure "vkGetQueryPoolResults"
      (vk:device
       vk:query-pool
       uint32-t
       uint32-t
       size-t
       uptr
       vk:device-size
       vk:query-result-flags)
      vk:result))
  (define vk:create-buffer
    (foreign-procedure "vkCreateBuffer"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-buffer
    (foreign-procedure "vkDestroyBuffer"
      (vk:device vk:buffer uptr)
      void))
  (define vk:create-buffer-view
    (foreign-procedure "vkCreateBufferView"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-buffer-view
    (foreign-procedure "vkDestroyBufferView"
      (vk:device vk:buffer-view uptr)
      void))
  (define vk:create-image
    (foreign-procedure "vkCreateImage"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-image
    (foreign-procedure "vkDestroyImage"
      (vk:device vk:image uptr)
      void))
  (define vk:get-image-subresource-layout
    (foreign-procedure "vkGetImageSubresourceLayout"
      (vk:device vk:image uptr uptr)
      void))
  (define vk:create-image-view
    (foreign-procedure "vkCreateImageView"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-image-view
    (foreign-procedure "vkDestroyImageView"
      (vk:device vk:image-view uptr)
      void))
  (define vk:create-shader-module
    (foreign-procedure "vkCreateShaderModule"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-shader-module
    (foreign-procedure "vkDestroyShaderModule"
      (vk:device vk:shader-module uptr)
      void))
  (define vk:create-pipeline-cache
    (foreign-procedure "vkCreatePipelineCache"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-pipeline-cache
    (foreign-procedure "vkDestroyPipelineCache"
      (vk:device vk:pipeline-cache uptr)
      void))
  (define vk:get-pipeline-cache-data
    (foreign-procedure "vkGetPipelineCacheData"
      (vk:device vk:pipeline-cache uptr uptr)
      vk:result))
  (define vk:merge-pipeline-caches
    (foreign-procedure "vkMergePipelineCaches"
      (vk:device vk:pipeline-cache uint32-t uptr)
      vk:result))
  (define vk:create-graphics-pipelines
    (foreign-procedure "vkCreateGraphicsPipelines"
      (vk:device vk:pipeline-cache uint32-t uptr uptr uptr)
      vk:result))
  (define vk:create-compute-pipelines
    (foreign-procedure "vkCreateComputePipelines"
      (vk:device vk:pipeline-cache uint32-t uptr uptr uptr)
      vk:result))
  (define vk:destroy-pipeline
    (foreign-procedure "vkDestroyPipeline"
      (vk:device vk:pipeline uptr)
      void))
  (define vk:create-pipeline-layout
    (foreign-procedure "vkCreatePipelineLayout"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-pipeline-layout
    (foreign-procedure "vkDestroyPipelineLayout"
      (vk:device vk:pipeline-layout uptr)
      void))
  (define vk:create-sampler
    (foreign-procedure "vkCreateSampler"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-sampler
    (foreign-procedure "vkDestroySampler"
      (vk:device vk:sampler uptr)
      void))
  (define vk:create-descriptor-set-layout
    (foreign-procedure "vkCreateDescriptorSetLayout"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-descriptor-set-layout
    (foreign-procedure "vkDestroyDescriptorSetLayout"
      (vk:device vk:descriptor-set-layout uptr)
      void))
  (define vk:create-descriptor-pool
    (foreign-procedure "vkCreateDescriptorPool"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-descriptor-pool
    (foreign-procedure "vkDestroyDescriptorPool"
      (vk:device vk:descriptor-pool uptr)
      void))
  (define vk:reset-descriptor-pool
    (foreign-procedure "vkResetDescriptorPool"
      (vk:device
       vk:descriptor-pool
       vk:descriptor-pool-reset-flags)
      vk:result))
  (define vk:allocate-descriptor-sets
    (foreign-procedure "vkAllocateDescriptorSets"
      (vk:device uptr uptr)
      vk:result))
  (define vk:free-descriptor-sets
    (foreign-procedure "vkFreeDescriptorSets"
      (vk:device vk:descriptor-pool uint32-t uptr)
      vk:result))
  (define vk:update-descriptor-sets
    (foreign-procedure "vkUpdateDescriptorSets"
      (vk:device uint32-t uptr uint32-t uptr)
      void))
  (define vk:create-framebuffer
    (foreign-procedure "vkCreateFramebuffer"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-framebuffer
    (foreign-procedure "vkDestroyFramebuffer"
      (vk:device vk:framebuffer uptr)
      void))
  (define vk:create-render-pass
    (foreign-procedure "vkCreateRenderPass"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-render-pass
    (foreign-procedure "vkDestroyRenderPass"
      (vk:device vk:render-pass uptr)
      void))
  (define vk:get-render-area-granularity
    (foreign-procedure "vkGetRenderAreaGranularity"
      (vk:device vk:render-pass uptr)
      void))
  (define vk:create-command-pool
    (foreign-procedure "vkCreateCommandPool"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-command-pool
    (foreign-procedure "vkDestroyCommandPool"
      (vk:device vk:command-pool uptr)
      void))
  (define vk:reset-command-pool
    (foreign-procedure "vkResetCommandPool"
      (vk:device vk:command-pool vk:command-pool-reset-flags)
      vk:result))
  (define vk:allocate-command-buffers
    (foreign-procedure "vkAllocateCommandBuffers"
      (vk:device uptr uptr)
      vk:result))
  (define vk:free-command-buffers
    (foreign-procedure "vkFreeCommandBuffers"
      (vk:device vk:command-pool uint32-t uptr)
      void))
  (define vk:begin-command-buffer
    (foreign-procedure "vkBeginCommandBuffer"
      (vk:command-buffer uptr)
      vk:result))
  (define vk:end-command-buffer
    (foreign-procedure "vkEndCommandBuffer"
      (vk:command-buffer)
      vk:result))
  (define vk:reset-command-buffer
    (foreign-procedure "vkResetCommandBuffer"
      (vk:command-buffer vk:command-buffer-reset-flags)
      vk:result))
  (define vk:cmd-bind-pipeline
    (foreign-procedure "vkCmdBindPipeline"
      (vk:command-buffer vk:pipeline-bind-point vk:pipeline)
      void))
  (define vk:cmd-set-viewport
    (foreign-procedure "vkCmdSetViewport"
      (vk:command-buffer uint32-t uint32-t uptr)
      void))
  (define vk:cmd-set-scissor
    (foreign-procedure "vkCmdSetScissor"
      (vk:command-buffer uint32-t uint32-t uptr)
      void))
  (define vk:cmd-set-line-width
    (foreign-procedure "vkCmdSetLineWidth"
      (vk:command-buffer float)
      void))
  (define vk:cmd-set-depth-bias
    (foreign-procedure "vkCmdSetDepthBias"
      (vk:command-buffer float float float)
      void))
  (define vk:cmd-set-blend-constants
    (foreign-procedure "vkCmdSetBlendConstants"
      (vk:command-buffer uptr)
      void))
  (define vk:cmd-set-depth-bounds
    (foreign-procedure "vkCmdSetDepthBounds"
      (vk:command-buffer float float)
      void))
  (define vk:cmd-set-stencil-compare-mask
    (foreign-procedure "vkCmdSetStencilCompareMask"
      (vk:command-buffer vk:stencil-face-flags uint32-t)
      void))
  (define vk:cmd-set-stencil-write-mask
    (foreign-procedure "vkCmdSetStencilWriteMask"
      (vk:command-buffer vk:stencil-face-flags uint32-t)
      void))
  (define vk:cmd-set-stencil-reference
    (foreign-procedure "vkCmdSetStencilReference"
      (vk:command-buffer vk:stencil-face-flags uint32-t)
      void))
  (define vk:cmd-bind-descriptor-sets
    (foreign-procedure "vkCmdBindDescriptorSets"
      (vk:command-buffer
       vk:pipeline-bind-point
       vk:pipeline-layout
       uint32-t
       uint32-t
       uptr
       uint32-t
       uptr)
      void))
  (define vk:cmd-bind-index-buffer
    (foreign-procedure "vkCmdBindIndexBuffer"
      (vk:command-buffer vk:buffer vk:device-size vk:index-type)
      void))
  (define vk:cmd-bind-vertex-buffers
    (foreign-procedure "vkCmdBindVertexBuffers"
      (vk:command-buffer uint32-t uint32-t uptr uptr)
      void))
  (define vk:cmd-draw
    (foreign-procedure "vkCmdDraw"
      (vk:command-buffer uint32-t uint32-t uint32-t uint32-t)
      void))
  (define vk:cmd-draw-indexed
    (foreign-procedure "vkCmdDrawIndexed"
      (vk:command-buffer
       uint32-t
       uint32-t
       uint32-t
       int32-t
       uint32-t)
      void))
  (define vk:cmd-draw-indirect
    (foreign-procedure "vkCmdDrawIndirect"
      (vk:command-buffer
       vk:buffer
       vk:device-size
       uint32-t
       uint32-t)
      void))
  (define vk:cmd-draw-indexed-indirect
    (foreign-procedure "vkCmdDrawIndexedIndirect"
      (vk:command-buffer
       vk:buffer
       vk:device-size
       uint32-t
       uint32-t)
      void))
  (define vk:cmd-dispatch
    (foreign-procedure "vkCmdDispatch"
      (vk:command-buffer uint32-t uint32-t uint32-t)
      void))
  (define vk:cmd-dispatch-indirect
    (foreign-procedure "vkCmdDispatchIndirect"
      (vk:command-buffer vk:buffer vk:device-size)
      void))
  (define vk:cmd-copy-buffer
    (foreign-procedure "vkCmdCopyBuffer"
      (vk:command-buffer vk:buffer vk:buffer uint32-t uptr)
      void))
  (define vk:cmd-copy-image
    (foreign-procedure "vkCmdCopyImage"
      (vk:command-buffer
       vk:image
       vk:image-layout
       vk:image
       vk:image-layout
       uint32-t
       uptr)
      void))
  (define vk:cmd-blit-image
    (foreign-procedure "vkCmdBlitImage"
      (vk:command-buffer
       vk:image
       vk:image-layout
       vk:image
       vk:image-layout
       uint32-t
       uptr
       vk:filter)
      void))
  (define vk:cmd-copy-buffer-to-image
    (foreign-procedure "vkCmdCopyBufferToImage"
      (vk:command-buffer
       vk:buffer
       vk:image
       vk:image-layout
       uint32-t
       uptr)
      void))
  (define vk:cmd-copy-image-to-buffer
    (foreign-procedure "vkCmdCopyImageToBuffer"
      (vk:command-buffer
       vk:image
       vk:image-layout
       vk:buffer
       uint32-t
       uptr)
      void))
  (define vk:cmd-update-buffer
    (foreign-procedure "vkCmdUpdateBuffer"
      (vk:command-buffer
       vk:buffer
       vk:device-size
       vk:device-size
       uptr)
      void))
  (define vk:cmd-fill-buffer
    (foreign-procedure "vkCmdFillBuffer"
      (vk:command-buffer
       vk:buffer
       vk:device-size
       vk:device-size
       uint32-t)
      void))
  (define vk:cmd-clear-color-image
    (foreign-procedure "vkCmdClearColorImage"
      (vk:command-buffer
       vk:image
       vk:image-layout
       uptr
       uint32-t
       uptr)
      void))
  (define vk:cmd-clear-depth-stencil-image
    (foreign-procedure "vkCmdClearDepthStencilImage"
      (vk:command-buffer
       vk:image
       vk:image-layout
       uptr
       uint32-t
       uptr)
      void))
  (define vk:cmd-clear-attachments
    (foreign-procedure "vkCmdClearAttachments"
      (vk:command-buffer uint32-t uptr uint32-t uptr)
      void))
  (define vk:cmd-resolve-image
    (foreign-procedure "vkCmdResolveImage"
      (vk:command-buffer
       vk:image
       vk:image-layout
       vk:image
       vk:image-layout
       uint32-t
       uptr)
      void))
  (define vk:cmd-set-event
    (foreign-procedure "vkCmdSetEvent"
      (vk:command-buffer vk:event vk:pipeline-stage-flags)
      void))
  (define vk:cmd-reset-event
    (foreign-procedure "vkCmdResetEvent"
      (vk:command-buffer vk:event vk:pipeline-stage-flags)
      void))
  (define vk:cmd-wait-events
    (foreign-procedure "vkCmdWaitEvents"
      (vk:command-buffer
       uint32-t
       uptr
       vk:pipeline-stage-flags
       vk:pipeline-stage-flags
       uint32-t
       uptr
       uint32-t
       uptr
       uint32-t
       uptr)
      void))
  (define vk:cmd-pipeline-barrier
    (foreign-procedure "vkCmdPipelineBarrier"
      (vk:command-buffer
       vk:pipeline-stage-flags
       vk:pipeline-stage-flags
       vk:dependency-flags
       uint32-t
       uptr
       uint32-t
       uptr
       uint32-t
       uptr)
      void))
  (define vk:cmd-begin-query
    (foreign-procedure "vkCmdBeginQuery"
      (vk:command-buffer
       vk:query-pool
       uint32-t
       vk:query-control-flags)
      void))
  (define vk:cmd-end-query
    (foreign-procedure "vkCmdEndQuery"
      (vk:command-buffer vk:query-pool uint32-t)
      void))
  (define vk:cmd-reset-query-pool
    (foreign-procedure "vkCmdResetQueryPool"
      (vk:command-buffer vk:query-pool uint32-t uint32-t)
      void))
  (define vk:cmd-write-timestamp
    (foreign-procedure "vkCmdWriteTimestamp"
      (vk:command-buffer
       vk:pipeline-stage-flag-bits
       vk:query-pool
       uint32-t)
      void))
  (define vk:cmd-copy-query-pool-results
    (foreign-procedure "vkCmdCopyQueryPoolResults"
      (vk:command-buffer
       vk:query-pool
       uint32-t
       uint32-t
       vk:buffer
       vk:device-size
       vk:device-size
       vk:query-result-flags)
      void))
  (define vk:cmd-push-constants
    (foreign-procedure "vkCmdPushConstants"
      (vk:command-buffer
       vk:pipeline-layout
       vk:shader-stage-flags
       uint32-t
       uint32-t
       uptr)
      void))
  (define vk:cmd-begin-render-pass
    (foreign-procedure "vkCmdBeginRenderPass"
      (vk:command-buffer uptr vk:subpass-contents)
      void))
  (define vk:cmd-next-subpass
    (foreign-procedure "vkCmdNextSubpass"
      (vk:command-buffer vk:subpass-contents)
      void))
  (define vk:cmd-end-render-pass
    (foreign-procedure "vkCmdEndRenderPass"
      (vk:command-buffer)
      void))
  (define vk:cmd-execute-commands
    (foreign-procedure "vkCmdExecuteCommands"
      (vk:command-buffer uint32-t uptr)
      void))
  (define vk:destroy-surface-khr
    (foreign-procedure "vkDestroySurfaceKHR"
      (vk:instance vk:surface-khr uptr)
      void))
  (define vk:get-physical-device-surface-support-khr
    (foreign-procedure "vkGetPhysicalDeviceSurfaceSupportKHR"
      (vk:physical-device uint32-t vk:surface-khr uptr)
      vk:result))
  (define vk:get-physical-device-surface-capabilities-khr
    (foreign-procedure "vkGetPhysicalDeviceSurfaceCapabilitiesKHR"
      (vk:physical-device vk:surface-khr uptr)
      vk:result))
  (define vk:get-physical-device-surface-formats-khr
    (foreign-procedure "vkGetPhysicalDeviceSurfaceFormatsKHR"
      (vk:physical-device vk:surface-khr uptr uptr)
      vk:result))
  (define vk:get-physical-device-surface-present-modes-khr
    (foreign-procedure "vkGetPhysicalDeviceSurfacePresentModesKHR"
      (vk:physical-device vk:surface-khr uptr uptr)
      vk:result))
  (define vk:create-swapchain-khr
    (foreign-procedure "vkCreateSwapchainKHR"
      (vk:device uptr uptr uptr)
      vk:result))
  (define vk:destroy-swapchain-khr
    (foreign-procedure "vkDestroySwapchainKHR"
      (vk:device vk:swapchain-khr uptr)
      void))
  (define vk:get-swapchain-images-khr
    (foreign-procedure "vkGetSwapchainImagesKHR"
      (vk:device vk:swapchain-khr uptr uptr)
      vk:result))
  (define vk:acquire-next-image-khr
    (foreign-procedure "vkAcquireNextImageKHR"
      (vk:device
       vk:swapchain-khr
       uint64-t
       vk:semaphore
       vk:fence
       uptr)
      vk:result))
  (define vk:queue-present-khr
    (foreign-procedure "vkQueuePresentKHR"
      (vk:queue uptr)
      vk:result))
  (define vk:get-physical-device-display-properties-khr
    (foreign-procedure "vkGetPhysicalDeviceDisplayPropertiesKHR"
      (vk:physical-device uptr uptr)
      vk:result))
  (define vk:get-physical-device-display-plane-properties-khr
    (foreign-procedure "vkGetPhysicalDeviceDisplayPlanePropertiesKHR"
      (vk:physical-device uptr uptr)
      vk:result))
  (define vk:get-display-plane-supported-displays-khr
    (foreign-procedure "vkGetDisplayPlaneSupportedDisplaysKHR"
      (vk:physical-device uint32-t uptr uptr)
      vk:result))
  (define vk:get-display-mode-properties-khr
    (foreign-procedure "vkGetDisplayModePropertiesKHR"
      (vk:physical-device vk:display-khr uptr uptr)
      vk:result))
  (define vk:create-display-mode-khr
    (foreign-procedure "vkCreateDisplayModeKHR"
      (vk:physical-device vk:display-khr uptr uptr uptr)
      vk:result))
  (define vk:get-display-plane-capabilities-khr
    (foreign-procedure "vkGetDisplayPlaneCapabilitiesKHR"
      (vk:physical-device vk:display-mode-khr uint32-t uptr)
      vk:result))
  (define vk:create-display-plane-surface-khr
    (foreign-procedure "vkCreateDisplayPlaneSurfaceKHR"
      (vk:instance uptr uptr uptr)
      vk:result))
  (define vk:create-shared-swapchains-khr
    (foreign-procedure "vkCreateSharedSwapchainsKHR"
      (vk:device uint32-t uptr uptr uptr)
      vk:result))
  (define vk:get-physical-device-external-image-format-properties-nv
    (foreign-procedure "vkGetPhysicalDeviceExternalImageFormatPropertiesNV"
      (vk:physical-device
       vk:format
       vk:image-type
       vk:image-tiling
       vk:image-usage-flags
       vk:image-create-flags
       vk:external-memory-handle-type-flags-nv
       uptr)
      vk:result)))
