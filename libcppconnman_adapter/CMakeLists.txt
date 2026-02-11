cmake_minimum_required(VERSION 3.14)

project(libcppconnman_adapter LANGUAGES C CXX)

include(FetchContent)

find_package(GDbusCpp QUIET)
if(NOT GDbusCpp_FOUND)
  FetchContent_Declare(
    GDbusCpp
    GIT_REPOSITORY https://github.com/amarula/libcppconnman.git
    GIT_TAG main)
  set(BUILD_CONNMAN ON)
  set(BUILD_SHARED_LIBS ON)
  FetchContent_MakeAvailable(GDbusCpp)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(BUILD_SHARED_LIBS ON)

add_library(${PROJECT_NAME} libcppconnman_adapter.cpp)
set_target_properties(${PROJECT_NAME} PROPERTIES VERSION 1.0.0 SOVERSION 1)
target_link_libraries(${PROJECT_NAME} Amarula::GConnmanDbus)
target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)

include(GNUInstallDirs)

install(
  TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}Targets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
