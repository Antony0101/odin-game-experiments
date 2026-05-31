#!/bin/bash

set -e

odin build src -out:output/game

./output/game
