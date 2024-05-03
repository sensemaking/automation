Add-Type -TypeDefinition @"
public enum Project
{
    All,
    None,
    Automation,
    Core,
    Persistence,
    Web,
    uPredict,
    Primitives,
    Authoring,
    Platform,
    ContentAuthoring,
    TppFileIngest,
    TppOpportunities,
    TppDaemon,
    Pid,
    Opportunities,
    TppPatientLoader
}
"@

function global:Get-Projects([Project] $project = [Project]::All) {
    $projects = @{ 
         [Project]::Automation       = [PSCustomObject]@{ 
             Git          = "git@github.com:sensemaking/automation.git"; 
             Directory    = "~\automation"; 
             CodeSolution = "~\automation"; 
         };
        [Project]::Core             = [PSCustomObject]@{ 
            Git        = "git@github.com:sensemaking/core.git"; 
            Directory  = "~\core"; 
            VsSolution = "~\core\Core.sln"; 
        };
        [Project]::Persistence      = [PSCustomObject]@{ 
            Git        = "git@github.com:sensemaking/persistence.git"; 
            Directory  = "~\persistence"; 
            VsSolution = "~\persistence\Persistence.sln"; 
        };
        [Project]::Web              = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/web.git"; 
            Directory    = "~\web";
            VsSolution   = "~\web\.net\Web.sln"; 
            CodeSolution = "~\web\js\core"; 
        };        
        [Project]::uPredict         = [PSCustomObject]@{ 
            Git          = "git@github.com:uPredict/uPredict.git"; 
            Directory    = "~\uPredict"; 
            VsSolution   = "~\uPredict\server\upredict.sln"; 
            CodeSolution = "~\uPredict\client"; 
            ServerHost   = "~\uPredict\server\web\host"; 
        };
        [Project]::Primitives       = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-primitives.git"; 
            Directory  = "~\fdb-rx-primitives"; 
            VsSolution = "~\fdb-rx-primitives\Primitives.sln"; 
        };
        [Project]::Authoring        = [PSCustomObject]@{
            Git          = "git@github.com:HearstHealthInternational/fdb-rx-authoring.git"; 
            Directory    = "~\fdb-rx-authoring"; 
            VsSolution   = "~\fdb-rx-authoring\Authoring.sln"; 
            CodeSolution = "~\fdb-rx-authoring\Pharaoh\UI\client"; 
            ServerHost   = "~\fdb-rx-authoring\Pharaoh\UI\server\host";
        };
        [Project]::Platform         = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-platform-common.git" 
            Directory  = "~\fdb-rx-platform-common"; 
            VsSolution = "~\fdb-rx-platform-common\Platform.Common.sln"; 
        };
        [Project]::TppFileIngest    = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-arx-tpp.git" 
            Directory  = "~\fdb-arx-tpp\Ingest\FileIngest"; 
            VsSolution = "~\fdb-arx-tpp\Ingest\FileIngest\Tpp.Files.Ingest.sln"; 
        };
        [Project]::TppPatientLoader = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-arx-tpp.git"; 
            Directory  = "~\fdb-arx-tpp\Ingest\PatientLoader"; 
            VsSolution = "~\fdb-arx-tpp\Ingest\PatientLoader\Tpp.PatientLoader.sln"; 
        };
        [Project]::TppDaemon        = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-arx-tpp.git" 
            Directory  = "~\fdb-arx-tpp\daemon"; 
            VsSolution = "~\fdb-arx-tpp\daemon\TppDaemon.sln"; 
        };
        [Project]::TppOpportunities = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-arx-tpp-opportunities.git" 
            Directory  = "~\fdb-arx-tpp\opportunities"; 
            VsSolution = "~\fdb-arx-tpp\opportunities\Tpp.Opportunities.sln"; 
        };
        [Project]::Pid              = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-arx-pid.git" 
            Directory  = "~\fdb-arx-pid"; 
            VsSolution = "~\fdb-arx-pid\Pid.sln"; 
        };
        [Project]::Opportunities    = [PSCustomObject]@{
            Git          = "git@github.com:HearstHealthInternational/fdb-arx-opportunities.git"; 
            Directory    = "~\fdb-arx-opportunities"; 
            VsSolution   = "~\fdb-arx-opportunities\Opportunities.sln"; 
            CodeSolution = "~\fdb-arx-opportunities\Web\Host\React"; 
            ServerHost   = "~\fdb-arx-opportunities\Web\Host";
        };
        [Project]::ContentAuthoring = [PSCustomObject]@{
            Git          = "git@github.com:HearstHealthInternational/fdb-arx-content-authoring.git"; 
            Directory    = "~\fdb-arx-content-authoring"; 
            VsSolution   = "~\fdb-arx-content-authoring\ContentAuthoring.sln"; 
            CodeSolution = "~\fdb-arx-content-authoring\React"; 
            ServerHost   = "~\fdb-arx-content-authoring\Host"; 
        };
    }

    return $projects.GetEnumerator() | Where-Object { $project -eq $_.Key -or $project -eq [Project]::All } 
}

function global:Update-Projects { 
    $automationDir = ((get-projects).GetEnumerator() | where { $_.Name -eq "Automation" }).Value.Directory 
    $profileDir = Split-Path $PROFILE
   
    if (!(Test-Path $automationDir)) { clone Automation }

    pull Automation
 
    Copy-Item "$automationDir\windows\powershell\Projects.ps1" -Destination "$profileDir\Projects.ps1" -fo
    Write-Host "`nUpdated projects. Reloading shell`n" -Fore Green
    powershell.exe -nologo
}