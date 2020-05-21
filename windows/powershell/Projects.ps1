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
    uPredict = 32,
    Core = 64,
    MobKata = 128,
    All = Automation + Common + Core + Persistence + Messaging + Web + uPredict + MobKata
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
        [Project]::uPredict = [PSCustomObject]@{ Git = "git@github.com:sensemaking/uPredict.git"; Directory = "~\uPredict"; Script = $null; VsSolution = "~\uPredict\uPredict.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::MobKata = [PSCustomObject]@{ Git = "git@github.com:sensemaking/MobKata.git"; Directory = "~\MobKata"; Script = $null; VsSolution = "~\MobKata\MobKata.sln"; CodeSolution = $null; HasJs = $false; };
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