# chez-vulkan

Vulkan graphics API binding for Chez Scheme.

![chezcube, one of the examples: a spinning cube with a λ on each face](docs/chezcube.gif)

## Libraries

- `(vulkan)` contains necessities of Vulkan API.
- `(vulkan constants)` defines some Vulkan constants omitted while auto-generating.

Window-system platforms:

- `(vulkan xlib)` (including `VK_EXT_acquire_xlib_display`)
- `(vulkan xcb)`
- `(vulkan wayland)`
- `(vulkan win32)`

The libraries load the Vulkan loader under its name on each platform:
`libvulkan.so.1` on Linux and other Unix systems, `vulkan-1.dll` on
Windows, and `libvulkan.1.dylib` (falling back to MoltenVK) on macOS.
Tested with Chez Scheme 10.4.1 on x86-64 Linux, and with the Windows build of
Chez Scheme 10.4.1 under Wine (the compute example and a Win32 surface).

## Using with Akku

The repository is an [Akku](https://akkuscm.org/) project. `akku install`
links every library under `.akku/lib` by its name, so inside the Akku
environment they can be imported directly:

```sh
akku install
.akku/env scheme
> (import (vulkan) (vulkan constants))
```

The bindings themselves have no dependencies; Akku.manifest lists
`image-formats` as a development dependency for the chezcube example.

## Examples

Run from the repository root:

- `scheme --script examples/compute/compute.ss [device-index]` — headless
  compute: squares 1000 floats in a storage buffer with a compute shader
  (`square.comp`, precompiled to `square.spv`) and checks the result.
- `scheme --script examples/gears/gears.ss [--device N] [--novsync]` —
  chezgears: the classic three spinning gears in an X11 window (XWayland on
  Wayland desktops), using dynamic rendering. Arrow keys and `z`/`Z` rotate
  the view, Esc quits. Needs only libX11 besides the Vulkan loader; the Xlib
  bindings are in `examples/x11.ss`.
- `.akku/env scheme --script examples/cube/cube.ss [--device N] [--novsync]`
  — chezcube: a spinning, lit cube textured with `lambda.png`, in a GLFW
  window (native Wayland or X11). Shows texture upload with mipmaps, a
  sampler and a descriptor set. Arrow keys rotate it, space pauses, Esc
  quits. Needs libglfw3 and, via `akku install`, the `image-formats` package
  for reading the PNG.

  `--step DEGREES` turns the cube by a fixed angle per frame instead of by
  elapsed time; the GIF at the top is 90 frames captured with `--step 4`.

  image-formats 0.1.0 decodes PNG rows that use the Paeth filter
  incorrectly and reads only 8-bit gray/RGB/RGBA images, so `lambda.png` is
  saved with unfiltered rows. To use another image, re-save it with
  `convert in.png -strip -define png:compression-filter=1 PNG24:out.png`.

Shared helpers: `examples/common.ss` (zeroed struct allocation with `new`,
result checking, Vulkan's two-call enumeration pattern), `examples/math.ss`
(4x4 matrices), and the window bindings `examples/x11.ss` and
`examples/glfw.ss`.

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

All of `vulkan.ss`, `xlib.ss`, `xcb.ss`, `wayland.ss` and `win32.ss` are
generated from the Vulkan headers (currently 1.4.363). Requires
[CastXML](https://github.com/CastXML/CastXML), a Vulkan loader
(`libvulkan.so.1`) and the X11, Xrandr, xcb and Wayland development
headers.

```sh
castxml --castxml-gccxml -DVK_USE_PLATFORM_XLIB_KHR \
  -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -DVK_USE_PLATFORM_XCB_KHR \
  -DVK_USE_PLATFORM_WAYLAND_KHR -o res/vulkan.xml /usr/include/vulkan/vulkan.h
scheme --script generate-vulkan.ss
```

`win32.ss` comes from a second parse of the headers for 64-bit Windows,
using the Windows SDK and MSVC headers (for example from
[msvc-wine](https://github.com/mstorsjo/msvc-wine)). The generator checks
that the core library from this parse is identical to `vulkan.ss`:

```sh
WINSDK_INCLUDE=.../Windows\ Kits/10/Include/10.0.26100.0 \
MSVC_INCLUDE=.../VC/Tools/MSVC/14.52.37025/include res/make-win32-xml.sh
scheme --script generate-vulkan.ss res/vulkan-win32.xml
```

Which functions get plain names is decided from the headers, not from the
installed loader, so regenerating anywhere gives the same bindings: the
functions every Vulkan loader exports (core 1.0–1.4 and the window-system
extensions: surface, swapchain, display, the platform surface functions)
are bound directly, and the rest get `vk:load-*` procedures. If a local
`libvulkan.so.1` is present, the generator also compares the result with its
exports and prints any differences as notes.

The generator checks every struct/union's size and field offsets against
CastXML's layout. C bitfields are exposed through named `(bits ...)` groups,
e.g. `(ftype-ref T (bits-0 field) p)`. The few structs whose names collide
with an enum value get a `-struct` suffix
(e.g. `vk:pipeline-cache-header-version-one-struct`). If you update the
headers, also update `vk:header-version` in `constants.ss`.

## TODO
- test on Windows itself (so far under Wine) and on macOS (MoltenVK)
