
sudo choco install 7zip -yr
sudo choco install slack -yr
sudo choco install dotnet-sdk -yr
sudo choco innstall zoom -yr

sudo choco install visualstudiocode -yr
sudo choco install sqllocaldb -yr

sudo choco install azure-data-studio -yr
sudo choco install azure-cli -yr
sudo choco install servicebusexplorer -yr

sudo choco install nodejs -yr
sudo choco install pnpm -yr

sudo irm https://claude.ai/install.ps1 | iex

sudo refreshenv

sudo dotnet tool install --global dotnet-outdated-tool        
sudo pnpm add -g npm-check-updates
sudo pnpm add -g vite

Read-Host "Computer will restart then please run .\automation\windows\configure.ps1"
Restart-Computer
