#!/bin/sh
# Parse the Vulkan headers for 64-bit Windows (MSVC ABI) into
# res/vulkan-win32.xml, from which `scheme --script generate-vulkan.ss
# res/vulkan-win32.xml` generates win32.ss.  Run from the repository root.
#
# Needs castxml, clang, and the Windows SDK and MSVC headers (for example
# from msvc-wine).  Set:
#   WINSDK_INCLUDE  the SDK's Include/<version> directory (with um, shared, ucrt)
#   MSVC_INCLUDE    MSVC's VC/Tools/MSVC/<version>/include directory
#   VULKAN_INCLUDE  the directory holding vulkan/ and vk_video/ (default /usr/include)
#
# Only the Vulkan headers are linked into res/win32-include, so no Linux C
# headers are seen.  Both outputs are ignored by git.
set -eu
: "${WINSDK_INCLUDE:?set WINSDK_INCLUDE to the Windows SDK Include/<version> directory}"
: "${MSVC_INCLUDE:?set MSVC_INCLUDE to the MSVC include directory}"
VULKAN_INCLUDE=${VULKAN_INCLUDE:-/usr/include}

inc=res/win32-include
rm -rf "$inc"
mkdir -p "$inc"
ln -s "$VULKAN_INCLUDE/vulkan" "$inc/vulkan"
ln -s "$VULKAN_INCLUDE/vk_video" "$inc/vk_video"

castxml --castxml-gccxml \
  --castxml-cc-gnu-c "(" clang --target=x86_64-pc-windows-msvc -nostdinc ")" \
  -nostdinc -fms-extensions -fms-compatibility \
  -isystem "$inc" -isystem "$(clang -print-resource-dir)/include" \
  -isystem "$MSVC_INCLUDE" -isystem "$WINSDK_INCLUDE/ucrt" \
  -isystem "$WINSDK_INCLUDE/shared" -isystem "$WINSDK_INCLUDE/um" \
  -DWIN32_LEAN_AND_MEAN -DVK_USE_PLATFORM_WIN32_KHR \
  -o res/vulkan-win32.xml "$inc/vulkan/vulkan.h"
