# chez-vulkan

Vulkan graphics API binding for Chez Scheme.

## Libraries

- `(vulkan)` contains necessities of Vulkan API.
- `(vulkan constants)` defines some Vulkan constants omitted while auto-generating.

Currently supported platforms are following:

- `(vulkan xlib)`
- `(vulkan win32)`
- `(vulkan wayland)`

## Examples

Run from the repository root:

- `scheme --script examples/compute/compute.ss [device-index]` — headless
  compute: squares 1000 floats in a storage buffer with a compute shader
  (`square.comp`, precompiled to `square.spv`) and checks the result.

## Extension functions

Functions the loader exports (core 1.0–1.4 and the WSI surface/swapchain
functions) are bound directly, e.g. `vk:create-instance`. Every other
function has a `vk:load-*` procedure that fetches it at runtime and returns
a callable procedure, or `#f` if it is unavailable (for example, the
extension was not enabled). Device-level functions (first parameter a
`VkDevice`, `VkQueue` or `VkCommandBuffer`) take a device; the rest take an
instance:

```scheme
(define draw-mesh-tasks (vk:load-cmd-draw-mesh-tasks-ext device))
(when draw-mesh-tasks
  (draw-mesh-tasks command-buffer x y z))
```

Each `vk:load-*` call looks the function up again, so load once and keep
the result.

## Regenerating

`vulkan.ss` is generated from the system Vulkan headers (currently 1.4.363).
Requires [CastXML](https://github.com/CastXML/CastXML) and a Vulkan loader
(`libvulkan.so.1`).

```sh
castxml --castxml-gccxml -o res/vulkan.xml /usr/include/vulkan/vulkan.h
scheme --script generate-vulkan.ss
```

The generator checks every struct/union's size and field offsets against
CastXML's layout. C bitfields are exposed through named `(bits ...)` groups,
e.g. `(ftype-ref T (bits-0 field) p)`. The few structs whose names collide
with an enum value get a `-struct` suffix
(e.g. `vk:pipeline-cache-header-version-one-struct`). If you update the
headers, also update `vk:header-version` in `constants.ss`.

## TODO
- xcb support
- mir support
- more examples (graphics/windowing)
- refine generator code
