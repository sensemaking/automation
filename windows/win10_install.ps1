
choco install conemu -yr
choco install 7zip -yr
choco install slack -yr
choco install teamviewer -yr
choco install dotnetcore-sdk -yr
choco install visualstudio2019community -yr
choco install visualstudiocode -yr
choco install sqllocaldb -yr
choco install sql-server-2017-cumulative-update -yr
choco install sqlserver-cmdlineutils -yr
choco install azure-cosmosdb-emulator
choco install azure-data-studio -yr
choco install azure-cli -yr
choco install servicebusexplorer -yr
choco install nodejs -yr
choco install yarn -yr

yarn global add npm-check-updates
yarn global add serve

Read-Host "Computer will restart then please run .\automation\windows\win10_configure.ps1"
Restart-Computer
