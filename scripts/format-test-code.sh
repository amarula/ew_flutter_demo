#!/bin/bash -e

FULL_PATH=$(realpath $0)
SCRIPT_PATH=$(dirname $FULL_PATH)

cd ${SCRIPT_PATH}/..

echo -e "----------------------------------------------------------------------------------\n"

echo -e "Formatting libcppconnman_adapter"
cd libcppconnman_adapter
cmake-format -i CMakeLists.txt
clang-format -i libcppconnman_adapter.cpp
cd ..

echo -e "Formatting libsensors_ffi"
cd libsensors_ffi
cmake-format -i CMakeLists.txt
clang-format -i libsensors_ffi.cpp
cd ..


echo -e "\n----------------------------------------------------------------------------------\n"

dart format lib

echo -e "\n----------------------------------------------------------------------------------\n"

dart run import_sorter:main

echo -e "\n----------------------------------------------------------------------------------\n"

flutter analyze
