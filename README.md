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

To avoid line-ending problems as noted below for Windows, consider creating repository ".gitattributes" file including relevant files to be patched including:

```ini
.gitattributes text eol=lf
.gitignore text eol=lf
*.build text eol=lf
*.c text eol=lf
*.cmake text eol=lf
*.cpp text eol=lf
*.patch text eol=lf
```

## Windows

On Windows, MSYS2 is looked to first, with fallback to Windows Subsystem for Linux (WSL).
To install patch in MSYS2, from the MSYS2 terminal:

```sh
pacman -S patch
```

NOTE: You will first need to one-time configure Git on Windows to use Unix-style line endings:

```sh
git config --global core.autocrlf input

git config --global core.eol lf
```


## Advanced example

More advanced projects such as those using FetchContent may need additional techniques.
This [example CMakeLists.txt](https://github.com/scivision/mumps/blob/3948131a6b28ad589effd4674a0067b9b3fd871e/src/CMakeLists.txt#L173)
shows that we had to rename some files to avoid collisons.
