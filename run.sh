#!/bin/bash

set -e

OUTPUT_DIR="./output"
RAYLIB_SRC="/usr/lib/odin/vendor/raylib/linux/libraylib.so.550"

if [ ! -f "$OUTPUT_DIR/libraylib.so.550" ]; then
    cp "$RAYLIB_SRC" "$OUTPUT_DIR/"
fi

odin build platform/dev -debug -out:output/platform -define:RAYLIB_SHARED=true -extra-linker-flags:'-Wl,-rpath,\$$ORIGIN' 

odin build src -build-mode:shared -debug -out:output/game.so -define:RAYLIB_SHARED=true 
# odin build src -out:output/lib

./output/platform

rm ./output/game*.so
