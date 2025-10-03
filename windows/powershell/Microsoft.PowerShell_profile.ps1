set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
cd ~

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
& $PSScriptRoot\AddEnvironmentPaths.ps1
& $PSScriptRoot\Projects.ps1

function Edit-Profile { code (Split-Path $PROFILE) }

function Edit-Nuget { code $env:USERPROFILE\AppData\Roaming\NuGet\NuGet.Config }

function Update-Automation { 
  $automationDir = (Get-Project Automation).Value.Directory 
  
  if (!(Test-Path $automationDir)) { clone Automation }

  pull Automation

  $profileDir = Split-Path $PROFILE
  Remove-Item "$profileDir\Modules\*" -r -for
  Copy-Item "$automationDir\windows\powershell\modules" $profileDir -r -fo
  Copy-Item "$automationDir\windows\powershell\AddEnvironmentPaths.ps1" -Destination "$profileDir\AddEnvironmentPaths.ps1" -fo
  
  Write-Host "`nUpdated automation scripts. Reloading shell`n" -Fore Green
  powershell.exe -nologo
}