cmake_minimum_required(VERSION 3.15)

project(LoopAuditioneer
  VERSION 0.8.8
  LANGUAGES C CXX
  DESCRIPTION "Software for loop and cue handling in .wav files"
  HOMEPAGE_URL "https://loopauditioneer.sourceforge.io/"
)

# External configuration CMake scripts
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/scripts/cmake")
include(Dependencies)
include(LoopAuditioneerConfig)
include(LoopAuditioneer)

message(STATUS "
CMake Generator:             ${CMAKE_GENERATOR}

Project name:                ${PROJECT_NAME}
Project version:             ${PROJECT_VERSION}
Build type:                  ${CMAKE_BUILD_TYPE}
Build processor:             ${LOOPAUDITIONEER_SYSTEM_PROCESSOR}
Use clang libc++:            ${LOOPAUDITIONEER_USE_LIBCPP}
Install prefix:              ${CMAKE_INSTALL_PREFIX}
Output directory:            ${CMAKE_BINARY_DIR}

wxWidgets version:           ${wxWidgets_VERSION_STRING}
wxWidgets static:            ${wxWidgets_DEFAULT_STATIC}
wxWidgets debug:             ${wxWidgets_DEFAULT_DEBUG}
wxWidgets unicode:           ${wxWidgets_DEFAULT_UNICODE}
wxWidgets CXX flags:         ${wxWidgets_CXX_FLAGS_LIST}

Compiler CXX debug flags:    ${CMAKE_CXX_FLAGS_DEBUG}
Compiler CXX release flags:  ${CMAKE_CXX_FLAGS_RELEASE}
Compiler CXX min size flags: ${CMAKE_CXX_FLAGS_MINSIZEREL}
")

# Debugging purpose
if(0)
  include(Utils)
  print_all_variables()
endif()
