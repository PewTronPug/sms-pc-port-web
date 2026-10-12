#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
source emsdk/emsdk_env.sh >/dev/null 2>&1

# Build with memory-efficient settings - graphics not available in web/WASM
emcmake cmake -S . -B build-web \
  -DCMAKE_BUILD_TYPE=MinSizeRel \
  -DSMS_WITH_GX=OFF \
  -DCMAKE_C_FLAGS_MINSIZEREL="-Os -flto=thin" \
  -DCMAKE_CXX_FLAGS_MINSIZEREL="-Os -flto=thin" \
  -DCMAKE_EXE_LINKER_FLAGS="-s WASM=1 -s ENVIRONMENT=web -s INITIAL_MEMORY=536870912 -s MAXIMUM_MEMORY=536870912 -s ALLOW_MEMORY_GROWTH=1"

# Single-threaded build to avoid memory spikes
cmake --build build-web -j1 --target sms 2>&1 | tee build-web.log
