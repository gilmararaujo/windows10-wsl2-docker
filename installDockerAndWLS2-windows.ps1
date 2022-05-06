#Virtual machine platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

#Windows subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# WSL 2 Kernel Update
Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile wsl_update_x64.msi -UseBasicParsing
msiexec /i wsl_update_x64.msi /passive /norestart 
rm wsl_update_x64.msi

#Standardize WSL 2
wsl --set-default-version 2

#Install Ubuntu 2004
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile linux.appx -UseBasicParsing
Add-AppxPackage -Path linux.appx
rm linux.appx

# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Docker-desktop and SQlServer 2019
choco install docker-desktop -y
# choco install sql-server-2019 -y
choco install wsl-ubuntu-2004 -y
choco install vscode -y
choco install sql-server-management-studio -y

# Create directory for sql save datafile
$path = "D:\mount\sql"
If(!(test-path $path))
{
    New-Item -ItemType Directory -Force -Path $path
}

# Create sqlserver docker image
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=secreto" -e "MSSQL_PID=Developer" -p 1433:1433 -d --name=sql -v //D/mount/sql:/var/opt/mssql/data mcr.microsoft.com/mssql/server:latest
# docker start sql
# docker stop sql