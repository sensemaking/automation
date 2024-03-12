Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None=0,
    Automation=1,
    Core=2,
    Persistence=4,
    Web=8,
    uPredict=16,
    Authoring=32,
    Publication=64,
    Platform=128,
    Rules=256,
    TppFileIngest=512,
    TppOpportunities=1024,
    TppDaemon=2048,
    Pid=4096,
    Opportunities=8192,
    All=Automation + Core + Persistence + Web + uPredict + Authoring + Publication + Platform + Rules  + TppFileIngest + TppOpportunities + TppDaemon + Pid + Opportunities
}
"@

function global:Get-Projects {
    return @{ 
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
        [Project]::Authoring        = [PSCustomObject]@{
            Git          = "git@github.com:HearstHealthInternational/fdb-rx-authoring.git"; 
            Directory    = "~\fdb-rx-authoring"; 
            VsSolution   = "~\fdb-rx-authoring\Authoring.sln"; 
            CodeSolution = "~\fdb-rx-authoring\Pharaoh\UI\client"; 
            ServerHost   = "~\fdb-rx-authoring\Pharaoh\UI\server\host";
        };
        [Project]::Publication      = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-authoring-publication.git"; 
            Directory  = "~\fdb-rx-authoring-publication"; 
            VsSolution = "~\fdb-rx-authoring-publication\Publication.sln"; 
        };
        [Project]::Platform         = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-platform-common.git" 
            Directory  = "~\fdb-rx-platform-common"; 
            VsSolution = "~\fdb-rx-platform-common\Platform.Common.sln"; 
        };
        [Project]::Rules            = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-rules.git" 
            Directory  = "~\fdb-rx-rules"; 
            VsSolution = "~\fdb-rx-rules\Rules.sln"; 
        };
        [Project]::TppFileIngest        = [PSCustomObject]@{
            Git = "git@github.com:HearstHealthInternational/fdb-arx-tpp.git" 
            Directory = "~\fdb-arx-tpp\ingest\FileIngest"; 
            VsSolution = "~\fdb-arx-tpp\ingest\FileIngest\Tpp.FileIngest.sln"; 
        };
        [Project]::TppDaemon        = [PSCustomObject]@{
            Git = "git@github.com:HearstHealthInternational/fdb-arx-tpp.git" 
            Directory = "~\fdb-arx-tpp\daemon"; 
            VsSolution = "~\fdb-arx-tpp\daemon\TppDaemon.sln"; 
        };
        [Project]::TppOpportunities = [PSCustomObject]@{
            Git = "git@github.com:HearstHealthInternational/fdb-arx-tpp-opportunities.git" 
            Directory = "~\fdb-arx-tpp\opportunities"; 
            VsSolution = "~\fdb-arx-tpp\opportunities\Tpp.Opportunities.sln"; 
        };
        [Project]::Pid              = [PSCustomObject]@{
            Git = "git@github.com:HearstHealthInternational/fdb-arx-pid.git" 
            Directory = "~\fdb-arx-pid"; 
            VsSolution = "~\fdb-arx-pid\Pid.sln"; 
        };
        [Project]::Opportunities    = [PSCustomObject]@{
            Directory = "~\fdb-arx-opportunities"; 
            CodeSolution = "~\fdb-arx-opportunities\Web\Host\React"; 
            VsSolution = "~\fdb-arx-opportunities\Opportunities.sln"; 
            Git = "git@github.com:HearstHealthInternational/fdb-arx-opportunities.git"; 
            ServerHost   = "~\fdb-arx-opportunities\Web\Host";
        };
    }
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