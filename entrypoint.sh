#!/bin/sh

readonly keyboard="$1"
readonly keymap="$2"

qmk compile -kb "$keyboard" -km "$keymap"

mkdir output
find "/qmk_firmware/.build" -name '*.hex' -or -name '*.bin' -exec cp {} ./output \;
ls output
