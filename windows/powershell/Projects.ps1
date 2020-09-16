Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None = 0,
    Automation = 1,
    Persistence = 4,
    Web = 8,
    uPredict = 16,
    Core = 32,
    MobKata = 64,
    PopulationAnalytics = 128,
    Provisioning = 256,
    AdfPH = 512,
    ContentAuthoring = 1024,
    RxCommon = 2048,
    RxMessaging = 4096,
    All = Automation + Core + Persistence + Web + uPredict + MobKata + PopulationAnalytics + Provisioning + ContentAuthoring, RxCommon, RxMessaging
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::Automation = [PSCustomObject]@{ Git = "git@github.com:sensemaking/automation.git"; Directory = "~\automation"; Script = $null; VsSolution = $null; CodeSolution = "~\automation"; HasJs = $false; };
        [Project]::Core = [PSCustomObject]@{ Git = "git@github.com:sensemaking/core.git"; Directory = "~\core"; Script = $null; VsSolution = "~\core\Core.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Persistence = [PSCustomObject]@{ Git = "git@github.com:sensemaking/persistence.git"; Directory = "~\persistence"; Script = $null; VsSolution = "~\persistence\Persistence.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Web = [PSCustomObject]@{ Git = "git@github.com:sensemaking/web.git"; Directory = "~\web"; Script = $null; VsSolution = "~\web\.net\Web.sln"; CodeSolution = "~\web\js\core"; HasJs = $true; };
        [Project]::uPredict = [PSCustomObject]@{ Git = "git@github.com:sensemaking/uPredict.git"; Directory = "~\uPredict"; Script = $null; VsSolution = "~\uPredict\Api\Api.sln"; CodeSolution = "~\uPredict\web"; HasJs = $false; };
        [Project]::MobKata = [PSCustomObject]@{ Git = "git@github.com:sensemaking/MobKata.git"; Directory = "~\MobKata"; Script = $null; VsSolution = "~\MobKata\MobKata.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::PopulationAnalytics = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/population-health-reporting.git"; Directory = "~\population-health-reporting"; Script = $null; VsSolution = "~\population-health-reporting\PopulationAnalytics.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Provisioning = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-rx-provisioning.git"; Directory = "~\fdb-rx-provisioning"; Script = $null; VsSolution = $null; CodeSolution = "~\fdb-rx-provisioning"; HasJs = $false; };
        [Project]::AdfPH = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/population-health-datafactory.git"; Directory = "~\population-health-datafactory"; Script = $null; VsSolution = $null; CodeSolution = "~\population-health-datafactory"; HasJs = $false; };
        [Project]::ContentAuthoring = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-arx-content-authoring.git"; Directory = "~\fdb-arx-content-authoring"; Script = $null; VsSolution = "~\fdb-arx-content-authoring\ContentAuthoring.sln"; CodeSolution = "~\fdb-arx-content-authoring\Host\Ui\Web\src"; HasJs = $true; };
        [Project]::RxCommon = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-rx-common.git"; Directory = "~\fdb-rx-common"; Script = $null; VsSolution = "~\fdb-rx-common"; CodeSolution = $null; HasJs = $false; };
        [Project]::RxMessaging = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-rx-messaging.git"; Directory = "~\fdb-rx-messaging"; Script = $null; VsSolution = "~\fdb-rx-messaging\Messaging.sln"; CodeSolution = $null; HasJs = $false; };
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