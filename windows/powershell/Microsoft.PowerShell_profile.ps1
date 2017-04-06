set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
set-location ~

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
& $PSScriptRoot\AddEnvironmentPaths.ps1
& $PSScriptRoot\Projects.ps1

(get-projects).GetEnumerator() | Where { [bool]$_.Value.Script } |  % { import-module $_.Value.Script }

function Edit-Profile {
    code (Split-Path $PROFILE)
}
