Disable-UAC
Disable-GameBarTips
Disable-MicrosoftUpdate
Disable-BingSearch

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-TaskbarOptions -Unlock -AutoHide -Dock Bottom -Combine Always
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key DontUsePowerShellOnWinX 0
Set-ItemProperty $key ShowTaskViewButton 0
Stop-Process -ProcessName explorer -Force

choco uninstall MicrosoftWindowsPowerShellV2Root -s windowsfeatures -yr
choco uninstall NetFx4-AdvSrvs -s windowsfeatures -yr
choco uninstall Printing-Foundation-Features -s windowsfeatures -yr
choco uninstall Printing-PrintToPDFServices-Features -s windowsfeatures -yr
choco uninstall Printing-XPSServices-Features -s windowsfeatures -yr
choco uninstall Xps-Foundation-Xps-Viewer -s windowsfeatures -yr
choco uninstall MSRDC-Infrastructure -s windowsfeatures -yr
choco uninstall SMB1Protocol -s windowsfeatures -yr
choco uninstall WorkFolders-Client -s windowsfeatures -yr
choco uninstall MediaPlayback -s windowsfeatures -yr



