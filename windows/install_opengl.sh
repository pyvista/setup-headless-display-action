#!/bin/bash
set -exo pipefail
ls -alt /C/Windows/System32/opengl32.dll

# Check if MESA3D_VERSION variable is set
if [ -z "${MESA3D_VERSION}" ]; then
  echo "MESA3D_VERSION is not set. Required to install Mesa3D..."
  exit 1
fi

NAME="mesa3d-${MESA3D_VERSION}-release-msvc"
curl -LO https://github.com/pal1000/mesa-dist-win/releases/download/${MESA3D_VERSION}/${NAME}.7z
7z x ${NAME}.7z -o./${NAME}
# Run systemwidedeploy.cmd file: option 1) Install OpenGL drivers & 7) Update system-wide deployment
cmd.exe //c "${NAME}\systemwidedeploy.cmd 1"
cmd.exe //c "${NAME}\systemwidedeploy.cmd 7"
# takeown "/f" "C:\Windows\System32\opengl32.dll"
# icacls "C:\Windows\System32\opengl32.dll" /grant "$USERNAME:F"
ls -alt /C/Windows/System32/opengl32.dll
