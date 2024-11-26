#!/bin/bash
set -exo pipefail

wget https://github.com/pal1000/mesa-dist-win/releases/download/24.2.7/mesa3d-24.2.7-release-msvc.7z
7z x mesa3d-24.2.7-release-msvc.7z
sudo mv mesa3d-24.2.7-release-msvc/x64/* /C/Windows/System32/
takeown /f "C:\Windows\System32\opengl32.dll"
icacls "C:\Windows\System32\opengl32.dll" /grant "$USERNAME:F"
