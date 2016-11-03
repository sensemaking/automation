import-module "$env:home\AppData\Roaming\Boxstarter\Boxstarter.Chocolatey"
install-WindowsUpdate -acceptEula

Get-AppxPackage *3d* | Remove-AppxPackage
Get-AppxPackage *alarms* | Remove-AppxPackage
Get-AppxPackage *bing* | Remove-AppxPackage
Get-AppxPackage *camera* | Remove-AppxPackage
Get-AppxPackage *communi* | Remove-AppxPackage
Get-AppxPackage *candy* | Remove-AppxPackage
Get-AppxPackage *farm* | Remove-AppxPackage
Get-AppxPackage *feedback* | Remove-AppxPackage
Get-AppxPackage *getstarted* | Remove-AppxPackage
Get-AppxPackage *messaging* | Remove-AppxPackage
Get-AppxPackage *netflix* | Remove-AppxPackage
Get-AppxPackage *office* | Remove-AppxPackage
Get-AppxPackage *oneconnect* | Remove-AppxPackage
Get-AppxPackage *people* | Remove-AppxPackage
Get-AppxPackage *phone* | Remove-AppxPackage
Get-AppxPackage *photo* | Remove-AppxPackage
Get-AppxPackage *skype* | Remove-AppxPackage
Get-AppxPackage *solit* | Remove-AppxPackage
Get-AppxPackage *soundrec* | Remove-AppxPackage
Get-AppxPackage *sticky* | Remove-AppxPackage
Get-AppxPackage *store* | Remove-AppxPackage
Get-AppxPackage *tunein* | Remove-AppxPackage
Get-AppxPackage *twitter* | Remove-AppxPackage
Get-AppxPackage *windowsmaps* | Remove-AppxPackage
Get-AppxPackage *xbox* | Remove-AppxPackage -erroraction 'silentlycontinue'
Get-AppxPackage *zune* | Remove-AppxPackage

rm $env:home\OneDrive -r -for
taskkill /f /im OneDrive.exe
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall

rm $env:home\Contacts -r -for -erroraction 'silentlycontinue'
rm $env:home\Favorites -r -for -erroraction 'silentlycontinue'
rm $env:home\Links -r -for -erroraction 'silentlycontinue'
rm $env:home\Music -r -for -erroraction 'silentlycontinue'
rm $env:home\Pictures -r -for -erroraction 'silentlycontinue'
rm $env:home\Searches -r -for -erroraction 'silentlycontinue'
rm "$env:home\Saved Games" -r -for -erroraction 'silentlycontinue'
rm $env:home\Videos -r -for -erroraction 'silentlycontinue'

write-host "`nRestart before running configuration and installation scripts`n" -fore red