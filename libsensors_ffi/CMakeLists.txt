cmake_minimum_required(VERSION 3.14)

project(libsensors_ffi LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(BUILD_SHARED_LIBS ON)

add_library(${PROJECT_NAME} libsensors_ffi.cpp)

target_link_libraries(${PROJECT_NAME})
