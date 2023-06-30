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
    Messaging=512,
    FdbPersistence=32768,
    Primitives=65536,
    All=Automation + Core + Persistence + Web + uPredict + Authoring + Publication + Platform + Rules + Messaging + FdbPersistence + Primitives
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::Automation     = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/automation.git"; 
            Directory    = "~\automation"; 
            CodeSolution = "~\automation"; 
        };
        [Project]::Core           = [PSCustomObject]@{ 
            Git        = "git@github.com:sensemaking/core.git"; 
            Directory  = "~\core"; 
            VsSolution = "~\core\Core.sln"; 
        };
        [Project]::Persistence    = [PSCustomObject]@{ 
            Git        = "git@github.com:sensemaking/persistence.git"; 
            Directory  = "~\persistence"; 
            VsSolution = "~\persistence\Persistence.sln"; 
        };
        [Project]::Web            = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/web.git"; 
            Directory    = "~\web";
            VsSolution   = "~\web\.net\Web.sln"; 
            CodeSolution = "~\web\js\core"; 
        };        
        [Project]::uPredict       = [PSCustomObject]@{ 
            Git          = "git@github.com:uPredict/uPredict.git"; 
            Directory    = "~\uPredict"; 
            VsSolution   = "~\uPredict\server\upredict.sln"; 
            CodeSolution = "~\uPredict\client"; 
            ServerHost   = "~\uPredict\server\web\host"; 
        };
        [Project]::Authoring      = [PSCustomObject]@{
            Git          = "git@github.com:HearstHealthInternational/fdb-rx-authoring.git"; 
            Directory    = "~\fdb-rx-authoring"; 
            VsSolution   = "~\fdb-rx-authoring\Authoring.sln"; 
            CodeSolution = "~\fdb-rx-authoring\Pharaoh\UI\client"; 
            ServerHost   = "~\fdb-rx-authoring\Pharaoh\UI\server\host";
        };
        [Project]::Publication    = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-authoring-publication.git"; 
            Directory  = "~\fdb-rx-authoring-publication"; 
            VsSolution = "~\fdb-rx-authoring-publication\Publication.sln"; 
        };
        [Project]::Platform  = [PSCustomObject]@{
            Git = "git@github.com:HearstHealthInternational/fdb-rx-platform-common.git" 
            Directory = "~\fdb-rx-platform-common"; 
            VsSolution = "~\fdb-rx-platform-common\Platform.Common.sln"; 
        };
        [Project]::Rules          = [PSCustomObject]@{
            Git = "git@github.com:HearstHealthInternational/fdb-rx-rules.git" };
            Directory = "~\fdb-rx-rules"; 
            VsSolution = "~\fdb-rx-rules\Rules.sln"; 
        };
        [Project]::FdbPersistence = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-persistence.git";
            Directory  = "~\fdb-rx-persistence"; 
            VsSolution = "~\fdb-rx-persistence\Persistence.sln"; 
        };
        [Project]::Messaging      = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-messaging.git";
            Directory  = "~\fdb-rx-messaging"; 
            VsSolution = "~\fdb-rx-messaging\Messaging.sln"; 
        };
        [Project]::Primitives     = [PSCustomObject]@{
            Git        = "git@github.com:HearstHealthInternational/fdb-rx-primitives.git";
            Directory  = "~\fdb-rx-primitives";
            VsSolution = "~\fdb-rx-primitives\Primitives.sln";
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