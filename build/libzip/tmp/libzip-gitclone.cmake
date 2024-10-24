
if(NOT "/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip-stamp/libzip-gitinfo.txt" IS_NEWER_THAN "/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip-stamp/libzip-gitclone-lastrun.txt")
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: '/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip-stamp/libzip-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E rm -rf "/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git"  clone --no-checkout --config "advice.detachedHead=false" "https://github.com/nih-at/libzip.git" "libzip"
    WORKING_DIRECTORY "/home/nttn/Documents/GitHub/wasmati/build/libzip/src"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/nih-at/libzip.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git"  checkout 66e496489bdae81bfda8b0088172871d8fda0032 --
  WORKING_DIRECTORY "/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: '66e496489bdae81bfda8b0088172871d8fda0032'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/usr/bin/git"  submodule update --recursive --init 
    WORKING_DIRECTORY "/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip"
    RESULT_VARIABLE error_code
    )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip-stamp/libzip-gitinfo.txt"
    "/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip-stamp/libzip-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/home/nttn/Documents/GitHub/wasmati/build/libzip/src/libzip-stamp/libzip-gitclone-lastrun.txt'")
endif()

