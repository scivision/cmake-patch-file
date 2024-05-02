find_package(Git REQUIRED)

set(CMAKE_EXECUTE_PROCESS_COMMAND_ECHO STDOUT)

# this is done here so that cmake --build build --clean-first also works

cmake_path(GET patch FILENAME patch_name)

configure_file("${in}" "${out}" COPYONLY)
configure_file(${patch} ${patch_name} COPYONLY)

execute_process(COMMAND ${GIT_EXECUTABLE} apply --ignore-whitespace "${patch_name}"
RESULT_VARIABLE ret
ERROR_VARIABLE err
TIMEOUT 5)
# if patch already applied - will fail

if(NOT ret EQUAL 0)
  execute_process(COMMAND ${GIT_EXECUTABLE} apply --ignore-whitespace --check -R "${patch_name}"
  RESULT_VARIABLE ret1
  ERROR_VARIABLE err1
  TIMEOUT 5)
  # if succeeds - patch sucessfully applied - conf OK

  if(NOT ret1 EQUAL 0)
    message(FATAL_ERROR "Patch ${patch} failed to apply:
    ${ret} ${err}
    ${ret1} ${err1}"
    )
  endif()

endif()
