# LibSndFile + Pitch Fraction
#===============================================================================
include(ExternalProject)

set(SNDFILE_PITCH_FRACTION_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/build/libsndfile")
set(SNDFILE_PITCH_FRACTION_SOURCE_DIR "${SNDFILE_PITCH_FRACTION_ROOT}/src")
set(SNDFILE_PITCH_FRACTION_LIBRARIES "${SNDFILE_PITCH_FRACTION_SOURCE_DIR}/.libs/libsndfile.a")
set(SNDFILE_PITCH_FRACTION_INCLUDE_DIRS "${SNDFILE_PITCH_FRACTION_SOURCE_DIR}")

function(SndfileBuildSetup)
  file(REMOVE_RECURSE "${SNDFILE_PITCH_FRACTION_ROOT}")
  file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/lib-src/libsndfile"
    DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/build")
  file(MAKE_DIRECTORY "${SNDFILE_PITCH_FRACTION_ROOT}/libs")
endfunction()

if(NOT EXISTS "${SNDFILE_PITCH_FRACTION_LIBRARIES}")
  SndfileBuildSetup()
endif()

ExternalProject_Add(sndfile-pf-dep
  PREFIX "${SNDFILE_PITCH_FRACTION_ROOT}"
  SOURCE_DIR "${SNDFILE_PITCH_FRACTION_SOURCE_DIR}"
  BINARY_DIR "${SNDFILE_PITCH_FRACTION_ROOT}"
  CONFIGURE_COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/scripts/sndfile-configure.sh"
  BUILD_COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/scripts/sndfile-make.sh"
  DOWNLOAD_COMMAND ""
  INSTALL_COMMAND ""
  UPDATE_COMMAND ""
)

add_library(sndfile-pf STATIC IMPORTED)
set_target_properties(sndfile-pf PROPERTIES IMPORTED_LOCATION "${SNDFILE_PITCH_FRACTION_LIBRARIES}")

# Threads
#===============================================================================
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

# LIBM: https://cmake.org/pipermail/cmake/2019-March/069168.html
#===============================================================================
include (CheckCSourceCompiles)
set (LIBM_TEST_SOURCE "#include<math.h>\nfloat f; int main(){sqrt(f);return 0;}")
check_c_source_compiles ("${LIBM_TEST_SOURCE}" HAVE_MATH)
if (HAVE_MATH)
  set (LIBM_LIBRARIES)
else()
  set (CMAKE_REQUIRED_LIBRARIES m)
  check_c_source_compiles("${LIBM_TEST_SOURCE}" HAVE_LIBM_MATH)
  unset (CMAKE_REQUIRED_LIBRARIES)
  if (NOT HAVE_LIBM_MATH)
    message (FATAL_ERROR "Unable to use C math library functions")
  endif()
  set (LIBM_LIBRARIES m)
endif()

# wxWidgets
#===============================================================================
find_package(wxWidgets 3.0.3 COMPONENTS core base adv html xrc REQUIRED)
if(${wxWidgets_FOUND})
  include(${wxWidgets_USE_FILE})
endif()

# Audio
#===============================================================================
find_package(PkgConfig REQUIRED)
if (PKGCONFIG_FOUND)
  pkg_check_modules (RTAUDIO "rtaudio" REQUIRED)
  pkg_check_modules (SAMPLERATE "samplerate" REQUIRED)
endif()
