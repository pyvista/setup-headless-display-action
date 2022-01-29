# Setup Headless Display Action

Setup a headless display on Linux using xvfb


## 🚀 Usage

```yml
name: Tests that require virtual display

on:
  pull_request:
  workflow_dispatch:
  push:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Setup Xvfb
        uses: pyvista/setup-headless-display-action@v0.0.1
```
