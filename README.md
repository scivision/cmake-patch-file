# CMake patch file

Use GNU Patch from CMake to patch source/headers/etc.

This works on Linux, MacOS, Windows, etc. assuming GNU Patch "patch" is installed.

This is a canonical CMake approach using 
[add_custom_command()](https://cmake.org/cmake/help/latest/command/add_custom_command.html)
that is only triggered if the input file changes.
It can also be used for FetchContent patching etc.

## Caveats

As per add_custom_command() docs, the add_custom_command() must be in the same directory as the consuming target.
Otherwise, add_custom_command() is not triggered and the file isn't patch.
If targets from multiple directories consume the patched file, 
ensure one of the targets is in the same directory as add_custom_command(),
then use add_dependencies() from the other targets to the target in the patch directory.

We show a non-basic case where we have a header file to patch, showing how to prepend include directories.
Compilers will prioritize include directories left-to-right.

## Windows

On Windows, MSYS2 is looked to first, with fallback to Windows Subsystem for Linux (WSL).
To install patch in MSYS2, from the MSYS2 terminal:

```sh
pacman -S patch
```
