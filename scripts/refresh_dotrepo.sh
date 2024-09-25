#!/bin/bash

CUR_DIR="${PWD}"
ROOT_DIR="$(realpath $(dirname ${0})/../..)"
BRANCH="$(cat ${ROOT_DIR}/branch)"

echo "Updating in ${ROOT_DIR}, branch: ${BRANCH}"
cd ${ROOT_DIR}

echo "cleaning up"
git reset --hard
git clean -xfd

echo "updating"
git checkout default
git branch -D bak
git branch -M bak
git fetch
git checkout "${BRANCH}"
git branch -M default
git submodule update

echo "Entering ${CUR_DIR}"
cd "${CUR_DIR}"
