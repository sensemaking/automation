choco install boxstarter --version 2.9.26 -yr

import-module "$env:userprofile\AppData\Roaming\Boxstarter\Boxstarter.Chocolatey"
install-WindowsUpdate -acceptEula

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
Get-AppxPackage *photo* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *skype* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *solit* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *soundrec* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *sticky* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *store* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *tunein* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *twitter* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *windowsmaps* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *xbox* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *zune* | Remove-AppxPackage -erroraction 'silentlycontinue'

rm $env:userprofile\OneDrive -r -for
taskkill /f /im OneDrive.exe
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall

rm $env:userprofile\Contacts -r -for -erroraction 'silentlycontinue'
rm $env:userprofile\Favorites -r -for -erroraction 'silentlycontinue'
rm $env:userprofile\Links -r -for -erroraction 'silentlycontinue'
rm $env:userprofile\Music -r -for -erroraction 'silentlycontinue'
rm $env:userprofile\Pictures -r -for -erroraction 'silentlycontinue'
rm $env:userprofile\Searches -r -for -erroraction 'silentlycontinue'
rm "$env:userprofile\Saved Games" -r -for -erroraction 'silentlycontinue'
rm $env:userprofile\Videos -r -for -erroraction 'silentlycontinue'

Read-Host "Computer will restart then please run .\automation\windows\win10_configure.ps1"
Restart-Computer
