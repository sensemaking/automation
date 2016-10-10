import-module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
import-module posh-git

set-variable -name HOME -value $smHome -force
(get-psprovider FileSystem).Home = $smHome
cd ~
 
$paths = 'c:\Program Files\Git\bin', 'c:\Program Files\Git\usr\bin', 'c:\Program Files\Git\cmd', 'c:\Windows\System32\inetsrv', 'c:\Program Files\Sublime Text 3'
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




# Load posh-git example profile
. 'C:\tools\poshgit\dahlbyk-posh-git-c39da78\profile.example.ps1'

#Rename-Item Function:\Prompt PoshGitPrompt -Force
#function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}
