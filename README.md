# CMake patch file

Use GNU Patch from CMake to patch source/headers/etc.

This works on Linux, MacOS, Windows, etc.
For Windows, it looks to MSYS2 with fallback to WSL for GNU Patch.

This is a canonical CMake approach that is only triggered if the input file changes.
It can also be used for FetchContent patching etc.

We show a non-basic case where we have a header file to patch, showing how to prepend include directories.
Compilers will prioritize include directories left-to-right.
