#!/usr/bin/env bash

OPENCV_VERSION=4.5.2
EMSDK_VERSION=2.0.10

set -euxo pipefail
cd `dirname $0`

if [ ! -d "opencv" ]; then
  git clone https://github.com/opencv/opencv.git -b ${OPENCV_VERSION} --depth=1 --single-branch opencv
fi

if [ ! -d "opencv_contrib" ]; then
  git clone https://github.com/opencv/opencv_contrib.git -b ${OPENCV_VERSION} --depth=1 --single-branch opencv_contrib
fi

git -C ./opencv checkout ${OPENCV_VERSION}
git -C ./opencv_contrib checkout ${OPENCV_VERSION}

docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) emscripten/emsdk:${EMSDK_VERSION} emcmake python3 opencv/platforms/js/build_js.py build_wasm --build_wasm --cmake_option="-DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules"

cp build_wasm/bin/opencv.js ../docs/js/opencv.js
