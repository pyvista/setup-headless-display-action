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

- `wm` (default `false`): Installs and starts a window manager on Linux. Set to
  `herbstluftwm` for a window manager on top of the Xvfb display, or to
  `weston` for a headless Wayland session *instead of* Xvfb, e.g.:

  ```yml
      - uses: pyvista/setup-headless-display-action@v3
        with:
          qt: true
          wm: weston
  ```

  `weston` is the odd one out, because a Wayland compositor replaces the
  display server rather than running on top of one. It starts headless
  [Weston](https://gitlab.freedesktop.org/wayland/weston) on the GL renderer
  and exports `WAYLAND_DISPLAY`, `XDG_RUNTIME_DIR`, `XDG_SESSION_TYPE=wayland`,
  and `QT_QPA_PLATFORM=wayland`, plus `LIBGL_ALWAYS_SOFTWARE=1` and
  `GALLIUM_DRIVER=llvmpipe` because the runners have no GPU and a Wayland
  client cannot fall back to OSMesa the way an X11 one can. The compositor log
  is left at `$WESTON_LOG`.

  No X server is started in that mode and `DISPLAY` is left unset, so a Qt
  binding missing its Wayland platform plugin fails loudly instead of quietly
  testing xcb.

  Only Linux is affected; on macOS and Windows this input is ignored.

- `mesa3d-release` (default `24.3.0`): set to a specific release to install
  that version of Mesa3D. This is only applicable for Windows. For example,
  to install Mesa3D 21.2.5:

  ```yml
      - uses: pyvista/setup-headless-display-action@v3
        with:
          mesa3d-release: 21.2.5
  ```

  You can also use `latest` to use the latest release version.

- `install-mesa3d-offscreen` (default `true`): installs the
  offscreen version of Mesa3D on Windows. This is only applicable for Windows.
  This will also set the `VTK_DEFAULT_OPENGL_WINDOW` environment variable to
  `vtkOSOpenGLRenderWindow` based on the [VTK Runtime settings](https://docs.vtk.org/en/latest/advanced/runtime_settings.html),
  and `LP_NUM_THREADS` to `0` so that llvmpipe renders on the calling thread;
  with its rasterizer threads active, a process that rendered can hang at exit.
  For example:

  ```yml
      - uses: pyvista/setup-headless-display-action@v3
        with:
          install-mesa3d-offscreen: true
  ```

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
