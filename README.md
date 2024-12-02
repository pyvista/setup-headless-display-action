# 📺 Setup Headless Display Action

Setup a headless display on Linux and Windows (not needed on MacOS)

```yml
- name: Setup headless display
  uses: pyvista/setup-headless-display-action@v3
```

## 🚀 Usage

```yml
name: Tests that require virtual display

on:
  pull_request:
  workflow_dispatch:
  push:
    tags:
      - "*"
    branches:
      - main

jobs:
  test:
    strategy:
      matrix:
        os: [macos-latest, ubuntu-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: pyvista/setup-headless-display-action@v3
```

### Options

- `qt` (default `false`): set to `true` to install libraries required for Qt
  on Linux, e.g.:
  ```yml
      - uses: pyvista/setup-headless-display-action@v3
        with:
          qt: true
  ```
- `pyvista` (default `true`): set to `false` if you don't want to set env
  vars to use PyVista in offscreen mode.

- `mesa3d-release` (default `24.3.0`): set to a specific release to install
  that version of Mesa3D. This is only applicable for Windows. For example,
  to install Mesa3D 21.2.5:
  ```yml
      - uses: pyvista/setup-headless-display-action@v3
        with:
          mesa3d-release: 21.2.5
  ```
  You can also use `latest` to use the latest release version.

### 🖼️ PyVista Example

```yml
name: Workflow that uses PyVista for plotting

on:
  pull_request:
  workflow_dispatch:
  push:
    tags:
      - "*"
    branches:
      - main

jobs:
  test:
    strategy:
      matrix:
        os: [macos-latest, ubuntu-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: pyvista/setup-headless-display-action@v3
      - uses: actions/setup-python@v5
        with:
          python-version: 3.12
      - run: pip install pyvista
      - run: python -c "import pyvista;pyvista.Sphere().plot(screenshot='${{ matrix.os }}-sphere.png')"
      - uses: actions/upload-artifact@v4
        with:
          name: sphere
          path: ${{ matrix.os }}-sphere.png
```
