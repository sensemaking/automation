set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
set-location ~

remove-item alias:curl

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
& $PSScriptRoot\AddEnvironmentPaths.ps1
& $PSScriptRoot\Projects.ps1

Ssh-SignIn 

function Edit-Profile { code (Split-Path $PROFILE) }

function Edit-Hosts { code c:\windows\system32\drivers\etc\hosts }

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

function prompt {
  $origLastExitCode = $LASTEXITCODE

  $maxPathLength = 40
  $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
  if ($curPath.Length -gt $maxPathLength) {
    $curPath = '...' + $curPath.SubString($curPath.Length - $maxPathLength + 3)
  }

  Write-Host $curPath -ForegroundColor Green
  $LASTEXITCODE = $origLastExitCode
  "$('>' * ($nestedPromptLevel + 1)) "
}