cmake_minimum_required(VERSION 2.6)
INCLUDE (CheckIncludeFiles) 

project(libortc)

set(CURL_LIB_DIR CACHE STRING "")
set(CURL_INC_DIR CACHE STRING "")
set(LWS_LIB_DIR CACHE STRING "")
set(LWS_INC_DIR CACHE STRING "")
set(REGEX_LIB CACHE STRING "")
set(REGEX_INC CACHE STRING "")
set(PTHREAD_LIB CACHE STRING "")
set(PTHREAD_INC CACHE STRING "")

find_package(Threads REQUIRED)
CHECK_INCLUDE_FILES(regex.h HAVE_REGEX_H)

#libcurl
find_package(CURL QUIET)
if(NOT CURL_FOUND)
  find_library(CURL_LIBRARIES
    NAMES curl curllib libcurl libcurl_imp curllib_static 
    HINTS "${CURL_LIB_DIR}" "$ENV{CURL_ROOT}"
    )
  if(NOT CURL_LIBRARIES)
    message(FATAL_ERROR "The curl library not found!\nRun the cmake with option -D CURL_LIB_DIR=/path/to/library or set the enviroment variable CURL_ROOT")
  endif()
  find_path(CURL_INCLUDE_DIRS
    curl/curl.h
    HITNS "${CURL_INC_DIR}" "$ENV{CURL_ROOT}" "$ENV{CURL_ROOT}/include"
    )
  if(NOT CURL_INCLUDE_DIRS)
    message(FATAL_ERROR "The curl includes not found!\nRun the cmake with option -D CURL_INC_DIR=/path/to/include or set the enviroment variable CURL_ROOT")
  endif()
endif()
message(STATUS "CURL library: ${CURL_LIBRARIES}")
message(STATUS "CURL include: ${CURL_INCLUDE_DIRS}")
include_directories("${CURL_INCLUDE_DIRS}")

#libwebsockets
find_library(LWS_LIBRARIES
  NAMES websockets websockets_static 
  HINTS "${LWS_LIB_DIR}" "$ENV{LIBWEBSOCKETS_LIB}"
  )
if(NOT LWS_LIBRARIES)
  message(FATAL_ERROR "The libwebsockets library not found!\nRun the cmake with option -D LWS_LIB_DIR=/path/to/library or set the enviroment variable LIBWEBSOCKETS_LIB")
endif()
find_path(LWS_INCLUDE_DIRS
  libwebsockets.h
  HITNS "${LWS_INC_DIR}" "$ENV{LIBWEBSOCKETS_INC}"
  )
if(NOT LWS_INCLUDE_DIRS)
  message(FATAL_ERROR "The libwebsockets includes not found!\nRun the cmake with option -D LWS_INC_DIR=/path/to/include or set the enviroment variable LIBWEBSOCKETS_INC")
endif()
message(STATUS "Libwebsockets library: ${LWS_LIBRARIES}")
message(STATUS "Libwebsockets include: ${LWS_INCLUDE_DIRS}")
include_directories("${LWS_INCLUDE_DIRS}")

#regex.h
if(NOT HAVE_REGEX_H)
  if(REGEX_LIB STREQUAL "")
    set(REGEX_LIB "$ENV{REGEX_LIB}")
  endif()
  if(REGEX_LIB STREQUAL "")
    message(FATAL_ERROR "No posix regular expresion library found!\nRun the cmake with option -D REGEX_LIB=/path/to/library or set the enviroment variable REGEX_LIB")
  endif()
  if(REGEX_INC STREQUAL "")
    set(REGEX_INC "$ENV{REGEX_INC}")
  endif()
  if(REGEX_INC STREQUAL "")
    message(FATAL_ERROR "The file regex.h not found!\nRun the cmake with option -D REGEX_INC=/path/to/regex.h or set the enviroment variable REGEX_INC")
  endif()
  message(STATUS "RegEx library: ${REGEX_LIB}")
  message(STATUS "RegEx include: ${REGEX_INC}")
  include_directories("${REGEX_INC}")
endif()

#pthread
if(APPLE)
	SET(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-pthread")
	include_directories(/usr/include/sys/)
else()
	if(NOT CMAKE_THREAD_LIBS_INIT)
	   if(PTHREAD_LIB STREQUAL "")
	    set(PTHREAD_LIB "$ENV{PTHREAD_LIB}")
	  endif()
	  if(PTHREAD_LIB STREQUAL "")
	    message(FATAL_ERROR "No pthread library found!\nRun the cmake with option -D PTHREAD_LIB=/path/to/library or set the enviroment variable PTHREAD_LIB")
	  endif()
	  if(PTHREAD_INC STREQUAL "")
	    set(PTHREAD_INC "$ENV{PTHREAD_INC}")
	  endif()
	  if(PTHREAD_INC STREQUAL "")
	    message(FATAL_ERROR "The file regex.h not found!\nRun the cmake with option -D PTHREAD_INC=/path/to/pthread.h or set the enviroment variable PTHREAD_INC")
	  endif()
	  message(STATUS "Pthread library: ${PTHREAD_LIB}")
	  message(STATUS "Pthread include: ${PTHREAD_INC}")
	  include_directories("${PTHREAD_INC}")
	endif()
endif()



add_subdirectory(lib)

add_subdirectory(example)