
choco install microsoft-windows-terminal -yr
choco install 7zip -yr
choco install visualstudio2019community -yr
choco install visualstudiocode -yr
choco install dotnetcore-sdk -yr
choco install sqllocaldb -yr
choco install sql-server-2017-cumulative-update -yr
choco install sqlserver-cmdlineutils -yr
choco install azure-data-studio -yr
choco install azure-cli -yr
choco install nodejs -yr
choco install yarn -yr
choco install postman -yr
choco install slack -yr
choco install microsoft-teams -yr
choco install teamviewer -yr
    
Read-Host "Computer will restart then please run .\automation\windows\win10_configure.ps1"
Restart-Computer
