cmake_minimum_required(VERSION 3.21)
project(CaelestiaBlobs VERSION 1.0 LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick ShaderTools)
qt_standard_project_setup(REQUIRES 6.5)

# Required by qml-module.cmake
set(INSTALL_QMLDIR "lib/qml")
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(cmake/pch.cmake)
include(cmake/qml-module.cmake)

add_subdirectory(src/Blobs)
