
choco install 7zip -yr
choco install slack -yr
choco install teamviewer -yr
choco install dotnet-sdk -yr
# Needs a refresh
dotnet tool install --global dotnet-outdated-tool        
choco install jetbrains-rider -yr
choco install visualstudiocode -yr
choco install sqllocaldb -yr
choco install azure-cosmosdb-emulator -yr
choco install azure-data-studio -yr
choco install azure-cli -yr
choco install servicebusexplorer -yr
choco install nodejs -yr
choco install pnpm -yr

# Needs a refresh
pnpm add -g npm-check-updates
pnpm add -g vite

Read-Host "Computer will restart then please run .\automation\windows\configure.ps1"
Restart-Computer
