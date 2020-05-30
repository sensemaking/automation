Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1

choco install conemu -yr
choco install brave -yr
choco install 7zip -yr
choco install teamviewer -yr
choco install slack -yr
choco install visualstudio2019community -yr
choco install visualstudiocode -yr
choco install dotnetcore-sdk -yr
choco install azure-cli -yr
choco install sqllocaldb -yr
choco install sql-server-management-studio -yr
choco install nodejs -yr
choco install yarn -yr
choco install postman -yr

Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ASPNET45

Get-ChildItem IIS:\Sites | % { Remove-Website $_.Name }
Get-ChildItem IIS:\AppPools | % { Remove-WebAppPool $_.Name }

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ComEmu.lnk")
$Shortcut.TargetPath = "$env:programFiles\ConEmu\ConEmu64.exe"
$Shortcut.Save()
    
Read-Host "Computer will restart then please run .\automation\windows\win10_configure.ps1"
Restart-Computer
