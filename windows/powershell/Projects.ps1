Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None = 0,
    Automation = 1,
    Common = 2,
    Persistence = 4,
    Messaging = 8,
    Web = 16,
    Slumber = 32,
    Core = 64,
    All = Automation + Common + Slumber
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::Automation = [PSCustomObject]@{ Git = "git@github.com:sensemaking/automation.git"; Directory = "~\automation"; Script = $null; VsSolution = $null; CodeSolution = "~\automation"; HasJs = $false; };
        [Project]::Common = [PSCustomObject]@{ Git = "git@github.com:sensemaking/common.git"; Directory = "~\common"; Script = $null; VsSolution = "~\common\Common.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Core = [PSCustomObject]@{ Git = "git@github.com:sensemaking/core.git"; Directory = "~\core"; Script = $null; VsSolution = "~\core\Core.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Persistence = [PSCustomObject]@{ Git = "git@github.com:sensemaking/persistence.git"; Directory = "~\persistence"; Script = $null; VsSolution = "~\persistence\Persistence.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Messaging = [PSCustomObject]@{ Git = "git@github.com:sensemaking/messaging.git"; Directory = "~\messaging"; Script = $null; VsSolution = "~\messaging\Messaging.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Web = [PSCustomObject]@{ Git = "git@github.com:sensemaking/web.git"; Directory = "~\web"; Script = $null; VsSolution = "~\web\Web.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Slumber = [PSCustomObject]@{ Git = "git@github.com:sensemaking/slumber.git"; Directory = "~\Slumber"; Script = $null; VsSolution = "~\Slumber\Slumber.sln"; CodeSolution = "~\Slumber\Host\Ui\Web\src"; HasJs = $true; };
    }
}

function global:Update-Projects { 
   $automationDir =((get-projects).GetEnumerator() | where { $_.Name -eq "Automation" }).Value.Directory 
   $profileDir = Split-Path $PROFILE
   
   if(!(Test-Path $automationDir)){ clone Automation }

   pull Automation
 
   Copy-Item "$automationDir\windows\powershell\Projects.ps1" -Destination "$profileDir\Projects.ps1" -fo
   powershell.exe -nologo
}