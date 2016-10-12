set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
cd ~

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
import-module "$env:ChocolateyToolsLocation\poshgit\*\posh-git"

$paths = "$env:programFiles(x86)\Google\Chrome\Application\", "$env:winDir\System32\inetsrv", "$env:programFiles\Sublime Text 3"
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