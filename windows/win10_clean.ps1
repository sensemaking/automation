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

taskkill /f /im OneDrive.exe
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall

$userDirectory = "c:\Users\$([Environment]::Username)"
rm $userDirectory\Contacts -r -for
rm $userDirectory\Favorites -r -for
rm $userDirectory\Links -r -for
rm $userDirectory\Music -r -for
rm $userDirectory\OneDrive -r -for
rm $userDirectory\Pictures -r -for
rm "$userDirectory\Searches" -r -for
rm "$userDirectory\Saved Games" -r -for
rm "$userDirectory\Videos" -r -for

