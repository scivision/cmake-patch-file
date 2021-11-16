# CMake patch file

Use GNU Patch from CMake to patch source/headers/etc.

This works on Linux, MacOS, Windows, etc. assuming GNU Patch "patch" is installed.

This is a canonical CMake approach that is only triggered if the input file changes.
It can also be used for FetchContent patching etc.

We show a non-basic case where we have a header file to patch, showing how to prepend include directories.
Compilers will prioritize include directories left-to-right.

## Windows

On Windows, MSYS2 is looked to first, with fallback to Windows Subsystem for Linux (WSL).
To install patch in MSYS2, from the MSYS2 terminal:

```sh
pacman -S patch
```
