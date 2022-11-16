function InstallDLL ($name) {
    $filepath = "C:\Windows\system32\$name"
    $sourcepath = "${env:ActionPath}\windows\mesa-$version\$name"
    takeown /F $filepath /A
    icacls $filepath /grant "${env:ComputerName}\${env:UserName}:F"
    Remove-item -LiteralPath $filepath
    Write-Host "${env:ActionPath}"
    Write-Host "Installing to" $filepath "from" $sourcepath
    Copy-Item $sourcepath -Destination $filepath
}


function InstallMesaOpenGL ($version) {
    InstallDLL "opengl32.dll"
    # InstallDLL "libglapi.dll"
}


function main () {
    InstallMesaOpenGL "22.0.1"
}

main
