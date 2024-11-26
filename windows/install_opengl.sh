#!/bin/bash
set -exo pipefail
VER="24.2.7"
NAME="mesa3d-${VER}-release-msvc"
curl -LO https://github.com/pal1000/mesa-dist-win/releases/download/${VER}/${NAME}.7z
7z x ${NAME}.7z -o./${NAME}
ls -alR ${NAME}/
mv -v ${NAME}/x64/* /C/Windows/System32/
rm -Rf ${NAME}
takeown /f "C:\Windows\System32\opengl32.dll"
icacls "C:\Windows\System32\opengl32.dll" /grant "$USERNAME:F"
