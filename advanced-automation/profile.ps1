$smHome = "C:\projects"
set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
set-location ~

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

& $PSScriptRoot\AddEnvironmentPaths.ps1
& $PSScriptRoot\Projects.ps1

(get-projects).GetEnumerator() | Where-Object { [bool]$_.Value.Script } | ForEach-Object { if (Test-Path -Path $_.Value.Script -PathType Leaf) {import-module $_.Value.Script -DisableNameChecking} }

set-alias sql ssms.exe
remove-item alias:curl

Ssh-SignIn

function Edit-Profile { code (Split-Path $PROFILE) }

function Edit-Hosts{ code c:\windows\system32\drivers\etc\hosts }

function Update-Automation { 
  $automationDir =((get-projects).GetEnumerator() | where { $_.Name -eq "Automation" }).Value.Directory 
  $profileDir = Join-Path (Split-Path $PROFILE) "Modules"
  
  if(!(Test-Path $automationDir)){ clone Automation }

  pull Automation

  mkdir "$profileDir\Build\" -fo
  Copy-Item "$automationDir\Build.psm1" -Destination "$profileDir\Build\Build.psm1" -fo

  mkdir "$profileDir\Git\" -fo
  Copy-Item "$automationDir\Git.psm1" -Destination "$profileDir\Git\Git.psm1" -fo

  mkdir "$profileDir\Web\" -fo
  Copy-Item "$automationDir\Web.psm1" -Destination "$profileDir\Web\Web.psm1" -fo

  powershell.exe
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
