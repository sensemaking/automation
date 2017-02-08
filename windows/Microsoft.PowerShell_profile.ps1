set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
cd ~

import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
import-module "c:\tools\poshgit\*\posh-git"

$paths = "$env:programFiles\Git\bin", "${env:programFiles(x86)}\Google\Chrome\Application\", "$env:winDir\System32\inetsrv", "${env:programFiles(x86)}\Skype\Phone", "${env:programFiles(x86)}\TeamViewer", "$env:userProfile\AppData\Local\slack\"
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

function Ssh-SignIn {
     Start-SshAgent
     & "$env:programFiles\Git\usr\bin\ssh-add.exe" $env:USERPROFILE\.ssh\sm_rsa
}