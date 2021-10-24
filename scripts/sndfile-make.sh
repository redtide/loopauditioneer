#!/bin/sh
set -e

echo "== BUILDING IN: $(pwd) =="
make
ln -sf src/.libs/libsndfile.a libs
