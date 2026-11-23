# chez-vulkan

Vulkan graphics API binding for Chez Scheme.

## Libraries

- `(vulkan)` contains necessities of Vulkan API.
- `(vulkan constants)` defines some Vulkan constants omitted while auto-generating.

Currently supported platforms are following:

- `(vulkan xlib)`
- `(vulkan win32)`
- `(vulkan wayland)`

## Regenerating

`vulkan.ss` is generated from the system Vulkan headers (currently 1.4.363).
Requires [CastXML](https://github.com/CastXML/CastXML) and a Vulkan loader
(`libvulkan.so.1`); only functions the loader exports are bound, extension
functions must be fetched with `vk:get-instance-proc-addr` /
`vk:get-device-proc-addr`.

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
- examples
- refine generator code
