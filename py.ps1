# Check if Python is installed
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
  # Download Python installer (adjust URL if needed)
  $url = "https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe"
  $output = "python-installer.exe"
  Invoke-WebRequest -Uri $url -OutFile $output

  # Install Python with silent installation and add to PATH
  Start-Process -FilePath $output -ArgumentList "/quiet InstallAllUsers=1 Include_test=0 Compileall=1 Shortcuts=1 Include_doc=0 Include_launcher=1  AssociateFiles=1  PrependPath=1" -Wait

  # Clean up the installer file
  Remove-Item $output
  Write-Host "Python installed successfully."
} else {
  Write-Host "Python is already installed."
}

# Verify installation
python --version
