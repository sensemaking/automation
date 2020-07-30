
Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1

choco install conemu -yr
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

Get-ChildItem IIS:\Sites | % { Remove-Website $_.Name }
Get-ChildItem IIS:\AppPools | % { Remove-WebAppPool $_.Name }
    
Read-Host "Computer will restart then please run .\automation\windows\win10_configure.ps1"
Restart-Computer
