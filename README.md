# Setup Headless Display Action

Setup a headless display on Linux and Windows (not needed on MacOS)


## 🚀 Usage

```yml
name: Tests that require virtual display

on:
  pull_request:
  workflow_dispatch:
  push:

jobs:
  test:
    strategy:
      matrix:
        os: [macos-latest, ubuntu-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - name: Setup headless Display
        uses: pyvista/setup-headless-display-action@v0.0.1
```
