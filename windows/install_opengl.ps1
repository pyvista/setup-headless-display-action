function InstallDLL ($name) {
    $scriptpath = Split-Path $MyInvocation.MyCommand.Path -Parent
    $filepath = "C:\Windows\system32\$name"
    $sourcepath = "$scriptpath\windows\mesa-$version\$name"
    takeown /F $filepath /A
    icacls $filepath /grant "${env:ComputerName}\${env:UserName}:F"
    Remove-item -LiteralPath $filepath
    Write-Host $scriptpath
    Write-Host "Installing to" $filepath "from" $sourcepath
    Copy-Item $sourcepath -Destination $filepath
}


function InstallMesaOpenGL ($version) {
    InstallDLL "opengl32.dll"
    # InstallDLL "libglapi.dll"
}


function main () {
    $scriptpath = $MyInvocation.MyCommand.Path
    Write-Output "Path of the script : $scriptpath"
    InstallMesaOpenGL "22.0.1"
}

main
