cmake_minimum_required(VERSION 3.21)

project(demo_patch LANGUAGES C)

enable_testing()

# patches "value.h" with "value.h.patch" using GNU Patch

add_custom_command(
OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/value.h
COMMAND ${CMAKE_COMMAND}
  -Din_file:FILEPATH=${CMAKE_CURRENT_SOURCE_DIR}/include/value.h
  -Dpatch_file:FILEPATH=${CMAKE_CURRENT_SOURCE_DIR}/value.h.patch
  -Dout_file:FILEPATH=${CMAKE_CURRENT_BINARY_DIR}/include/value.h
  -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/PatchFile.cmake
DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/include/value.h
)

add_executable(hello
hello.c
${CMAKE_CURRENT_BINARY_DIR}/include/value.h
)
# specify header file so that add_custom_command() is triggered
target_include_directories(hello PRIVATE include)
target_include_directories(hello BEFORE PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/include)

add_test(NAME include_patch COMMAND hello)
