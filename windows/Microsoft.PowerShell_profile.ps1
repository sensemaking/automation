set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
cd ~

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
import-module "c:\tools\poshgit\*\posh-git"

$paths = "$env:programFiles\Git\bin", "${env:programFiles(x86)}\Google\Chrome\Application\", "$env:winDir\System32\inetsrv", "${env:programFiles(x86)}\Skype\Phone", "C:\Program Files (x86)\TeamViewer", "C:\Users\efdp\AppData\Local\slack\app-2.3.2"
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