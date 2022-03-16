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

On Windows if GNU Patch isn't on PATH, we assume that Git Bash is installed and look there for Patch.
This is much simpler and more reliable than prior methods of using MSYS2 or WSL.

## Advanced example

More advanced projects such as those using FetchContent may need additional techniques.
This [example CMakeLists.txt](https://github.com/scivision/mumps/blob/3948131a6b28ad589effd4674a0067b9b3fd871e/src/CMakeLists.txt#L173)
shows that we had to rename some files to avoid collisons.
