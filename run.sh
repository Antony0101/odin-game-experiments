#!/bin/bash

set -e

odin build platform/dev -debug -out:output/platform -define:RAYLIB_SHARED=true -extra-linker-flags:'-Wl,-rpath,\$$ORIGIN' 

odin build src -build-mode:shared -debug -out:output/game.so -define:RAYLIB_SHARED=true 
# odin build src -out:output/lib

./output/platform
