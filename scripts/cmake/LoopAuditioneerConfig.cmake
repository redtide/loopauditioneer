# The variable CMAKE_SYSTEM_PROCESSOR is incorrect on Visual studio, see
# https://gitlab.kitware.com/cmake/cmake/issues/15170
if(NOT LOOPAUDITIONEER_SYSTEM_PROCESSOR)
  if(MSVC)
    set(LOOPAUDITIONEER_SYSTEM_PROCESSOR "${MSVC_CXX_ARCHITECTURE_ID}")
  else()
    set(LOOPAUDITIONEER_SYSTEM_PROCESSOR "${CMAKE_SYSTEM_PROCESSOR}")
  endif()
endif()

# LOOPAUDITIONEER_USE_LIBCPP: libc++ is enabled by default on macOS.
include(CMakeDependentOption)
cmake_dependent_option(LOOPAUDITIONEER_USE_LIBCPP "Use libc++ with clang" "${APPLE}"
  "CMAKE_CXX_COMPILER_ID MATCHES Clang" OFF)
if(LOOPAUDITIONEER_USE_LIBCPP)
  add_compile_options(-stdlib=libc++)
  if(CMAKE_VERSION VERSION_LESS 3.13)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -lc++abi")
  else()
    add_link_options(-stdlib=libc++ -lc++abi)
  endif()
endif()
