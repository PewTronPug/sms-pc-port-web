#!/bin/bash
# Usage: ./build-web.sh [target]   (default target: sms_game)
set -o pipefail
cd "$(dirname "$0")"
source emsdk/emsdk_env.sh >/dev/null 2>&1
command -v cmake >/dev/null || sudo apt-get install -y cmake patch
TARGET="${1:-sms_game}"
{
  emcmake cmake -S . -B build-web -DCMAKE_BUILD_TYPE=RelWithDebInfo -DSMS_WITH_GX=OFF &&
  cmake --build build-web -j4 --target "$TARGET" -- -k
} > build-web.log 2>&1
rc=$?
{
  echo "exit code: $rc   target: $TARGET"
  echo "== error kinds (count, message) =="
  grep -E "error:" build-web.log | sed -E 's/^[^ ]+ error: //' | sort | uniq -c | sort -rn | head -25
  echo "== first errors =="
  grep -E "error:" build-web.log | head -12
  echo "== cmake errors =="
  grep -n "CMake Error" -A4 build-web.log | head -20
  echo "== last 15 lines =="
  tail -15 build-web.log
} > build-web-summary.txt
echo "done, exit $rc"
