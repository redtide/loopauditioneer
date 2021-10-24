set(HEADER_FILES
  src/AudioSettingsDialog.h
  src/AutoLoopDialog.h
  src/AutoLooping.h
  src/BatchProcessDialog.h
  src/CrossfadeDialog.h
  src/CueMarkers.h
  src/CutNFadeDialog.h
  src/FFT.h
  src/FileHandling.h
  src/ListInfoDialog.h
  src/LoopAuditioneer.h
  src/LoopAuditioneerDef.h
  src/LoopMarkers.h
  src/LoopOverlay.h
  src/LoopParametersDialog.h
  src/MyFrame.h
  src/MyListCtrl.h
  src/MyPanel.h
  src/MyResampler.h
  src/MySound.h
  src/PitchDialog.h
  src/StopHarmonicDialog.h
  src/WaveformDrawer.h
)
set(SOURCE_FILES
  src/AudioSettingsDialog.cpp
  src/AutoLoopDialog.cpp
  src/AutoLooping.cpp
  src/BatchProcessDialog.cpp
  src/CrossfadeDialog.cpp
  src/CueMarkers.cpp
  src/CutNFadeDialog.cpp
  src/FFT.cpp
  src/FileHandling.cpp
  src/ListInfoDialog.cpp
  src/LoopAuditioneer.cpp
  src/LoopMarkers.cpp
  src/LoopOverlay.cpp
  src/LoopParametersDialog.cpp
  src/MyFrame.cpp
  src/MyListCtrl.cpp
  src/MyPanel.cpp
  src/MyResampler.cpp
  src/MySound.cpp
  src/PitchDialog.cpp
  src/StopHarmonicDialog.cpp
  src/WaveformDrawer.cpp
)
# wxxrc "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/resources.xrc" -vco \
#       "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/resources.cpp"
#
# bin2c "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/help/help.zip"
#       "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/help.zip.h"

set(CMAKE_INCLUDE_CURRENT_DIR ON) # needed by help.zip.h
set(RESOURCE_FILES
  resources/application/resources.cpp
  resources/application/resources.xrc
  resources/application/help.zip.h
)
source_group("Resource Files" FILES ${RESOURCE_FILES})

if(0)
# Copy the resources in the build directory to debug the application
if(APPLE)
  set(LOOP_AUDITIONEER_SHARED_DIR "${CMAKE_BINARY_DIR}/LoopAuditioneer.app/Contents/SharedSupport")
elseif(WIN32)
  set(LOOP_AUDITIONEER_SHARED_DIR "${CMAKE_BINARY_DIR}")
else()
  set(LOOP_AUDITIONEER_SHARED_DIR "${CMAKE_BINARY_DIR}/share/loopauditioneer")
endif()

function(copy_resources)
  file(REMOVE_RECURSE "${LOOP_AUDITIONEER_SHARED_DIR}")
  file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/help/help.zip"
     DESTINATION "${LOOP_AUDITIONEER_SHARED_DIR}/help"
  )
  file(COPY
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/icons/"
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/free-pixel-icons/24x24"
    DESTINATION "${LOOP_AUDITIONEER_SHARED_DIR}/icons"
    FILES_MATCHING
      PATTERN "*.png"
  )
endfunction()
copy_resources()
endif(0)

if(APPLE)
  set(MACOSX_BUNDLE_ICON_FILE icon.icns)
  set(MAC_APP_ICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/macos/icon.icns")
  set_source_files_properties(${MAC_APP_ICON} PROPERTIES
    MACOSX_PACKAGE_LOCATION "Resources"
  )
  add_executable(${CMAKE_PROJECT_NAME}
    MACOSX_BUNDLE
    ${RESOURCE_FILES}
    ${HEADER_FILES}
    ${SOURCE_FILES}
    ${LOOPAUDITIONEER_MAC_ICON}
  )
elseif(WIN32)
  list(APPEND SOURCE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/resources/windows/icon.rc")
  add_executable(${CMAKE_PROJECT_NAME}
    WIN32
    ${RESOURCE_FILES}
    ${HEADER_FILES}
    ${SOURCE_FILES}
  )
  set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    SUFFIX ".exe"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<0:>"
  )
else()
  add_executable(${CMAKE_PROJECT_NAME}
    ${RESOURCE_FILES}
    ${HEADER_FILES}
    ${SOURCE_FILES}
  )
  set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "loopauditioneer"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
  )
endif()

add_dependencies(${CMAKE_PROJECT_NAME} sndfile-pf-dep)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
  ${RTAUDIO_INCLUDE_DIRS}
  ${SNDFILE_PITCH_FRACTION_INCLUDE_DIRS}
)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
  Threads::Threads
  ${LIBM_LIBRARIES}
  ${RTAUDIO_LIBRARIES}
  ${SAMPLERATE_LIBRARIES}
  ${SNDFILE_PITCH_FRACTION_LIBRARIES}
  ${wxWidgets_LIBRARIES}
)
if(UNIX AND NOT APPLE)
  include(GNUInstallDirs)
  install(TARGETS ${CMAKE_PROJECT_NAME}
    DESTINATION ${CMAKE_INSTALL_BINDIR}
  )
if(0)
  install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/icons"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/loopauditioneer"
  )
  install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/free-pixel-icons/24x24"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/loopauditioneer/icons"
  )
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/resources/application/help/help.zip"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/loopauditioneer/help"
  )
endif(0)
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/resources/loopauditioneer.png"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/pixmaps"
  )
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/resources/linux/org.loopauditioneer.LoopAuditioneer.desktop"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/applications"
  )
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/resources/linux/org.loopauditioneer.LoopAuditioneer.appdata.xml"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/metainfo"
  )
endif()
