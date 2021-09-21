Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None = 0,
    Automation = 1,
    Core = 2,
    Persistence = 4,
    Web = 8,
    PopulationAnalytics = 16,
    ContentAuthoring = 32,
    Pharaoh = 64,
    Common = 128,    
    Messaging = 256,
    PlatformCommon = 512,
    Rules = 1024,
    Swaps = 2048,
    FdbWeb = 4096,
    uPredict = 8192,
    Opportunities = 16384,
    FdbPersistence = 32768,
    Primitives = 65536,
    All = Automation + Core + Persistence + Web + PopulationAnalytics + ContentAuthoring + Pharaoh + Common + FdbWeb + Messaging + PlatformCommon + Rules + Swaps + uPredict + Opportunities + FdbPersistence + Primitives
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::Automation = [PSCustomObject]@{ Git = "git@github.com:sensemaking/automation.git"; Directory = "~\automation"; Script = $null; VsSolution = $null; CodeSolution = "~\automation"; HasJs = $false; };
        [Project]::Core = [PSCustomObject]@{ Git = "git@github.com:sensemaking/core.git"; Directory = "~\core"; Script = $null; VsSolution = "~\core\Core.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Persistence = [PSCustomObject]@{ Git = "git@github.com:sensemaking/persistence.git"; Directory = "~\persistence"; Script = $null; VsSolution = "~\persistence\Persistence.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Web = [PSCustomObject]@{ Git = "git@github.com:sensemaking/web.git"; Directory = "~\web"; Script = $null; VsSolution = "~\web\Web.sln"; CodeSolution = "~\web\js\core"; HasJs = $true; };        
        [Project]::PopulationAnalytics = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/population-analytics.git"; Directory = "~\population-analytics"; Script = $null; VsSolution = "~\population-analytics\PopulationAnalytics.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::ContentAuthoring = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-arx-content-authoring.git"; Directory = "~\fdb-arx-content-authoring"; Script = $null; VsSolution = "~\fdb-arx-content-authoring\ContentAuthoring.sln"; CodeSolution = "~\fdb-arx-content-authoring\Host\Ui\Web\src"; HasJs = $true; };
        [Project]::Common = [PSCustomObject]@{Directory = "~\fdb-rx-common"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-common\Common.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-common.git" };
        [Project]::FdbWeb = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-rx-web.git"; Directory = "~\fdb-rx-web"; Script = $null; VsSolution = "~\fdb-rx-web\.net\Web.sln"; CodeSolution = $null; HasJs = $false; };        
        [Project]::Messaging = [PSCustomObject]@{Directory = "~\fdb-rx-messaging"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-messaging\Messaging.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-messaging.git" };
        [Project]::Pharaoh = [PSCustomObject]@{Directory = "~\fdb-rx-authoring"; HasJs = $true; CodeSolution = "~\fdb-rx-authoring\Pharaoh\UI\client"; VsSolution = "~\fdb-rx-authoring\Authoring.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-authoring.git" };
        [Project]::PlatformCommon = [PSCustomObject]@{Directory = "~\fdb-rx-platform-common"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-platform-common\Platform.Common.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-platform-common.git" };
        [Project]::Rules = [PSCustomObject]@{Directory = "~\fdb-rx-rules"; HasJs = $false;  CodeSolution = $null; VsSolution = "~\fdb-rx-rules\Rules.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-rules.git" };
        [Project]::Swaps = [PSCustomObject]@{Directory = "~\fdb-rx-swaps"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-swaps\Swaps.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-swaps.git" };
        [Project]::uPredict = [PSCustomObject]@{Directory = "~\uPredict"; HasJs = $true; CodeSolution = "~\uPredict\client"; VsSolution = "~\uPredict\server\upredict.sln"; Script = $null; Git = "git@github.com:uPredict/uPredict.git" };
        [Project]::Opportunities = [PSCustomObject]@{Directory = "~\fdb-arx-opportunities"; HasJs = $true;  IncludesNetFrameworkProjects = $true; CodeSolution = "~\fdb-arx-opportunities\Host\Ui\Web\src"; VsSolution = "~\fdb-arx-opportunities\Opportunities.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-arx-opportunities.git" };
        [Project]::FdbPersistence = [PSCustomObject]@{Directory = "~\fdb-rx-persistence"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-persistence\Persistence.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-persistence.git" };
        [Project]::Primitives = [PSCustomObject]@{Directory = "~\fdb-rx-primitives"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-primitives\Primitives.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-primitives.git" };
    }
}

function global:Update-Projects { 
   $automationDir =((get-projects).GetEnumerator() | where { $_.Name -eq "Automation" }).Value.Directory 
   $profileDir = Split-Path $PROFILE
   
   if(!(Test-Path $automationDir)){ clone Automation }

   pull Automation
 
   Copy-Item "$automationDir\windows\powershell\Projects.ps1" -Destination "$profileDir\Projects.ps1" -fo
   Write-Host "`nUpdated projects. Reloading shell`n" -Fore Green
   powershell.exe -nologo
}