#!/bin/sh
set -e

echo "=== CONFIGURING FROM: $(pwd) ==="
aclocal
automake
./configure \
  --disable-external-libs \
  --enable-static
