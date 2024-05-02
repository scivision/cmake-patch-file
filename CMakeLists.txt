# patches "value.h" under build directory with "value.h.patch" using Git apply

cmake_minimum_required(VERSION 3.20)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "In-source builds are not allowed.
  cmake -B build")
endif()

project(demo_patch LANGUAGES CXX)

enable_testing()

add_custom_command(
OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/value.h
COMMAND ${CMAKE_COMMAND}
  -Din:FILEPATH=${CMAKE_CURRENT_SOURCE_DIR}/include/value.h
  -Dout:FILEPATH=${CMAKE_CURRENT_BINARY_DIR}/include/value.h
  -Dpatch:FILEPATH=${CMAKE_CURRENT_SOURCE_DIR}/value.h.patch
  -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/PatchFile.cmake
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_executable(hello main.cpp ${CMAKE_CURRENT_BINARY_DIR}/include/value.h)
# specify header file so that add_custom_command() is triggered
target_include_directories(hello PRIVATE include)
target_include_directories(hello BEFORE PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/include)
# BEFORE to prioritize patched value.h
target_compile_features(hello PRIVATE cxx_std_11)

add_test(NAME include_patch COMMAND hello)

file(GENERATE OUTPUT .gitignore CONTENT "*")
