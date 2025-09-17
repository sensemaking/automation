

choco uninstall NetFx4-AdvSrvs -s windowsfeatures -yr
choco uninstall Printing-Foundation-Features -s windowsfeatures -yr
choco uninstall Printing-PrintToPDFServices-Features -s windowsfeatures -yr
choco uninstall Printing-XPSServices-Features -s windowsfeatures -yr
choco uninstall MSRDC-Infrastructure -s windowsfeatures -yr
choco uninstall SMB1Protocol -s windowsfeatures -yr
choco uninstall WorkFolders-Client -s windowsfeatures -yr
choco uninstall MediaPlayback -s windowsfeatures -yr
choco uninstall MicrosoftWindowsPowerShellV2Root -s windowsfeatures -yr
choco uninstall MicrosoftWindowsPowerShellV2 -s windowsfeatures -yr
choco uninstall Internet-Explorer-Optional-amd64 -s windowsfeatures -yr


Write-Host "Check out https://github.com/Raphire/Win11Debloat is still about. Run with custom options set"
Read-Host "Computer will restart then please run .\automation\windows\install.ps1"
Restart-Computer
