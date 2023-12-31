#!/bin/sh

readonly keyboard="$1"
readonly keymap="$2"
readonly qmk_output="$3"

qmk compile -kb "$keyboard" -km "$keymap"

mkdir "$qmk_output"
find "/qmk_firmware/.build" -name '*.hex' -or -name '*.bin' -exec cp -v {} "$qmk_output" \;
