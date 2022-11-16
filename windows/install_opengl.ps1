function InstallMesaOpenGL ($version) {
    $filepath = "C:\Windows\system32\opengl32.dll"
    takeown /F $filepath /A
    icacls $filepath /grant "${env:ComputerName}\${env:UserName}:F"
    Remove-item -LiteralPath $filepath
    Write-Host "Installing to" $filepath
    Copy-Item "${env:ActionPath}\windows\mesa-$version\opengl32.dll" -Destination $filepath
}


function main () {
    InstallMesaOpenGL "22.0.1"
}

main
