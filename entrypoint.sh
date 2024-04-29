#!/bin/sh

set -e

readonly keyboard="$1"
readonly keymap="$2"
readonly controller="$3"
readonly qmk_output="$4"
readonly local_keymap="$5"

# Check if the controller matches one of the available options
if [ "$controller" ]; then
  if [ "$controller" != "proton_c" ] && [ "$controller" != "kb2040" ] && [ "$controller" != "promicro_rp2040" ] && [ "$controller" != "blok" ] && [ "$controller" != "bit_c_pro" ] && [ "$controller" != "stemcell" ] && [ "$controller" != "bonsai_c4" ] && [ "$controller" != "rp2040_ce" ] && [ "$controller" != "elite_pi" ] && [ "$controller" != "helios" ] && [ "$controller" != "liatris" ] && [ "$controller" != "imera" ] && [ "$controller" != "michi" ]; then
    echo "Invalid convert option $keyboard"
    exit 1
  fi
fi

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
echo Controller - "$controller"
qmk compile -kb "$keyboard" -km "$keymap" ${controller:+-e CONVERT_TO="$controller"}

mkdir "$qmk_output"
find "/opt/qmk_firmware/.build" \( -name '*.hex' -or -name '*.bin' -or -name '*.uf2' \) -exec cp -v {} "$qmk_output" \;

echo "built-images=$(find "$qmk_output" -type f | sed "s|^$qmk_output||" | paste -sd ',')" \
  >> "$GITHUB_OUTPUT"
