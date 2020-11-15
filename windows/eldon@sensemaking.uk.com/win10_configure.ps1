choco install boxstarter

import-module "$env:ALLUSERSPROFILE\Boxstarter\Boxstarter.Chocolatey"
Disable-GameBarTips
Disable-BingSearch

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-BoxstarterTaskbarOptions -Unlock -Dock Bottom -Combine Always -Size Small
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key DontUsePowerShellOnWinX 0
Set-ItemProperty $key ShowTaskViewButton 0
Stop-Process -ProcessName explorer -Force
