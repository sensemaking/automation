Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None = 0,
    Automation = 1,
    Common = 2,
    Persistence = 4,
    Web = 8,
    uPredict = 16,
    Core = 32,
    MobKata = 64,
    PopulationHealth = 128,
    FdbProvisioning = 256,
    All = Automation + Common + Core + Persistence + Web + uPredict + MobKata + PopulationHealth + FdbProvisioning
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::Automation = [PSCustomObject]@{ Git = "git@github.com:sensemaking/automation.git"; Directory = "~\automation"; Script = $null; VsSolution = $null; CodeSolution = "~\automation"; HasJs = $false; };
        [Project]::Common = [PSCustomObject]@{ Git = "git@github.com:sensemaking/common.git"; Directory = "~\common"; Script = $null; VsSolution = "~\common\Common.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Core = [PSCustomObject]@{ Git = "git@github.com:sensemaking/core.git"; Directory = "~\core"; Script = $null; VsSolution = "~\core\Core.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Persistence = [PSCustomObject]@{ Git = "git@github.com:sensemaking/persistence.git"; Directory = "~\persistence"; Script = $null; VsSolution = "~\persistence\Persistence.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Web = [PSCustomObject]@{ Git = "git@github.com:sensemaking/web.git"; Directory = "~\web"; Script = $null; VsSolution = "~\web\.net\Web.sln"; CodeSolution = "~\web\js\core"; HasJs = $true; };
        [Project]::uPredict = [PSCustomObject]@{ Git = "git@github.com:sensemaking/uPredict.git"; Directory = "~\uPredict"; Script = $null; VsSolution = "~\uPredict\Api\Api.sln"; CodeSolution = "~\uPredict\web"; HasJs = $false; };
        [Project]::MobKata = [PSCustomObject]@{ Git = "git@github.com:sensemaking/MobKata.git"; Directory = "~\MobKata"; Script = $null; VsSolution = "~\MobKata\MobKata.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::PopulationHealth = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-population-health.git"; Directory = "~\fdb-population-health"; Script = $null; VsSolution = "~\fdb-population-health\PopulationHealth.sln"; CodeSolution = $null; HasJs = $false; };
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