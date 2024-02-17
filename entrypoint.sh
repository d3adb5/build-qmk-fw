#!/bin/sh

set -e

readonly keyboard="$1"
readonly keymap="$2"
readonly qmk_output="$3"
readonly local_keymap="$4"

# Find the keymaps directory the same way QMK CLI does
if [ -n "$local_keymap" ]; then
  keymap_lookup_dir="/opt/qmk_firmware/keyboards/$keyboard"

  until find "$keymap_lookup_dir" -type d -name keymaps | grep -q .; do
    keymap_lookup_dir=$(dirname "$keymap_lookup_dir")
  done

  if [ "$keymap_lookup_dir" = "/opt/qmk_firmware/keyboards" ]; then
    echo "Could not find keymaps directory for $keyboard"
    exit 1
  fi

  echo "Copying local keymap into $keymap_lookup_dir/keymaps"
  cp -rv "$local_keymap" "$keymap_lookup_dir/keymaps/$(basename "$local_keymap")"
fi

qmk config user.qmk_home=/opt/qmk_firmware
qmk compile -kb "$keyboard" -km "$keymap"

mkdir "$qmk_output"
find "/opt/qmk_firmware/.build" \( -name '*.hex' -or -name '*.bin' \) -exec cp -v {} "$qmk_output" \;

echo "built-images=$(find "$qmk_output" -type f | sed "s|^$qmk_output||" | paste -sd ',')" \
  >> "$GITHUB_OUTPUT"
