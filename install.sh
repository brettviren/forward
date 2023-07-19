#!/bin/bash

prefix="$(realpath "${1:-"$HOME/opt/forward"}")"
echo "installing to $prefix"

me="$(realpath "$BASH_SOURCE")"
top="$(dirname "$me")"
# -DCMAKE_PREFIX_PATH="$top" \
cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CXX_STANDARD=17 \
      -DCMAKE_INSTALL_PREFIX="$prefix" \
      -DWITH_PYTHON=yes -S . -B build
cmake --build build -j "$(nproc)"
cmake --install build

$prefix/bin/test_forward > /dev/null || exit 1

PYTHONPATH="$prefix/lib/python3.11/site-packages/" python -c 'import forward' || exit 1
