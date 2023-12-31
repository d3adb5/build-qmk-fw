# Build QMK Firmware

Build QMK firmware for your keyboard using your keymap with GitHub Actions.

## Options

| Input               | Description                                                    | Required | Default      |
|:--------------------|:---------------------------------------------------------------|:---------|:-------------|
| `keyboard`          | The target keyboard for this firmware build                    | Yes      |              |
| `keymap`            | The keymap to build for this firmware                          | Yes      | `default`    |
| `local-keymap-path` | Path to a local keymap directory to inject into the QMK home   | No       | ` `          |
| `output-dir`        | Directory in the workspace where built firmware will be placed | No       | `qmk-output` |

The `output-dir` input is the directory in your GitHub Actions workflow's
workspace where the built firmware images will be placed. The `built-images`
output will be set to a comma-separated list of files placed in that directory.

## Example

```yaml
name: Build my QMK configuration

on:
  push:
    branches:
      - master
  pull_request: {}

jobs:
  build-qmk:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
      - uses: d3adb5/build-qmk-fw@v1
        with:
          keyboard: dztech/dz65rgb/v3
          keymap: my-keymap
          local-keymap-path: keymaps/my-keymap
          output-dir: qmk-firmware-to-be-flashed

      - uses: actions/upload-artifact@v4
        with:
          name: built-images
          path: qmk-firmware-to-be-flashed
```
