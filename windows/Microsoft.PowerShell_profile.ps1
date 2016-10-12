set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
cd ~

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
import-module "$env:ChocolateyToolsLocation\poshgit\*\posh-git"

$paths = "$env:windir\System32\inetsrv", "c:\Program Files\Sublime Text 3"
$paths | % {
	if(-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}
	
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    write-host($pwd.ProviderPath) -nonewline
    write-vcsStatus
    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}