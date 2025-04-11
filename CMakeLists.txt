cmake_minimum_required(VERSION 3.16)

project(Q3D_Rendering_Car VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick Quick3D)
qt_add_big_resources(QRC_RESOURCES resource.qrc)
list(APPEND QRC_RESOURCES resource.qrc)
qt_add_executable(appQ3D_Rendering_Car
    main.cpp
    ${QRC_RESOURCES}
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQ3D_Rendering_Car PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQ3D_Rendering_Car
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQ3D_Rendering_Car
    PRIVATE Qt6::Quick
    Qt6::Quick3D
)

include(GNUInstallDirs)
install(TARGETS appQ3D_Rendering_Car
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
