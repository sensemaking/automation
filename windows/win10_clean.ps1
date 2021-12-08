
Get-AppxPackage *3d* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *alarms* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *bing* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *camera* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *communi* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *candy* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *farm* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *feedback* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *getstarted* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *messaging* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *netflix* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *office* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *oneconnect* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *people* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *phone* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *skype* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *solit* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *soundrec* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *sticky* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *tunein* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *twitter* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *windowsmaps* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *xbox* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *zune* | Remove-AppxPackage -erroraction 'silentlycontinue'

taskkill /f /im OneDrive.exe
Remove-Item $env:userprofile\OneDrive -r -for
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall

choco uninstall NetFx4-AdvSrvs -s windowsfeatures -yr
choco uninstall Printing-Foundation-Features -s windowsfeatures -yr
choco uninstall Printing-PrintToPDFServices-Features -s windowsfeatures -yr
choco uninstall Printing-XPSServices-Features -s windowsfeatures -yr
choco uninstall Xps-Foundation-Xps-Viewer -s windowsfeatures -yr
choco uninstall MSRDC-Infrastructure -s windowsfeatures -yr
choco uninstall SMB1Protocol -s windowsfeatures -yr
choco uninstall WorkFolders-Client -s windowsfeatures -yr
choco uninstall MediaPlayback -s windowsfeatures -yr
choco uninstall SmbDirect -s windowsfeatures -yr
choco uninstall MicrosoftWindowsPowerShellV2Root -s windowsfeatures -yr
choco uninstall MicrosoftWindowsPowerShellV2 -s windowsfeatures -yr
choco uninstall Internet-Explorer-Optional-amd64 -s windowsfeatures -yr

Write-Host "Consider running https://github.com/Sycnex/Windows10Debloater"
Read-Host "Computer will restart then please run .\automation\windows\win10_install.ps1"
Restart-Computer
