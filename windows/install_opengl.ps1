# Adapted from VisPy
$MESA_GL_URL = "https://github.com/pyvista/setup-headless-display-action/raw/mesa/windows/mesa-22.3.0/"

function DownloadMesaOpenGL ($architecture) {
    [Net.ServicePointManager]::SecurityProtocol = 'Tls, Tls11, Tls12'
    $webclient = New-Object System.Net.WebClient
    # Download and retry up to 3 times in case of network transient errors.
    $url = $MESA_GL_URL + "opengl32" + ".dll"
    if ($architecture -eq "32") {
        $filepath = "C:\Windows\SysWOW64\opengl32.dll"
    } else {
        $filepath = "C:\Windows\system32\opengl32.dll"
    }
    takeown /F $filepath /A
    icacls $filepath /grant "${env:ComputerName}\${env:UserName}:F"
    Remove-item -LiteralPath $filepath
    Write-Host "Downloading" $url
    $retry_attempts = 2
    for($i=0; $i -lt $retry_attempts; $i++){
        try {
            $webclient.DownloadFile($url, $filepath)
            break
        }
        Catch [Exception]{
            Start-Sleep 1
        }
    }
    if (Test-Path $filepath) {
        Write-Host "File saved at" $filepath
    } else {
        # Retry once to get the error message if any at the last try
        $webclient.DownloadFile($url, $filepath)
    }
}


function main () {
    DownloadMesaOpenGL "64"
}

main
