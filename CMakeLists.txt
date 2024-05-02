cmake_minimum_required(VERSION 3.14...3.30)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "In-source builds are not allowed.
  cmake -B build")
endif()

project(demo_patch LANGUAGES CXX)

enable_testing()

# patches "value.h" with "value.h.patch" using GNU Patch

file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include)
# avoids failure if dir not exist

# avoids hassle with line endings on Windows that --ignore-whitespace doesn't help
if(WIN32)
configure_file(value.h.patch value.h.patch NEWLINE_STYLE CRLF)
configure_file(include/value.h include/value.h NEWLINE_STYLE CRLF)
else()
configure_file(value.h.patch value.h.patch COPYONLY)
configure_file(include/value.h include/value.h COPYONLY)
endif()

add_custom_command(
OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/value.h
COMMAND ${CMAKE_COMMAND}
  -Din_file:FILEPATH=${CMAKE_CURRENT_BINARY_DIR}/include/value.h
  -Dpatch_file:FILEPATH=${CMAKE_CURRENT_BINARY_DIR}/value.h.patch
  -Dout_file:FILEPATH=${CMAKE_CURRENT_BINARY_DIR}/include/value.h
  -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/PatchFile.cmake
DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/include/value.h
)

add_executable(hello main.cpp ${CMAKE_CURRENT_BINARY_DIR}/include/value.h)
# specify header file so that add_custom_command() is triggered
target_include_directories(hello PRIVATE include)
target_include_directories(hello BEFORE PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/include)
# BEFORE to prioritize patched value.h
target_compile_features(hello PRIVATE cxx_std_11)

add_test(NAME include_patch COMMAND hello)

file(GENERATE OUTPUT .gitignore CONTENT "*")
