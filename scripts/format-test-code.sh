#!/bin/bash -e

FULL_PATH=$(realpath $0)
SCRIPT_PATH=$(dirname $FULL_PATH)

cd ${SCRIPT_PATH}/..

dart format lib test

echo -e "\n----------------------------------------------------------------------------------\n"

dart run import_sorter:main

echo -e "\n----------------------------------------------------------------------------------\n"

flutter analyze

echo -e "\n----------------------------------------------------------------------------------\n"

flutter test
