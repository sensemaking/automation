Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None = 0,
    Automation = 1,
    Core = 2,
    Persistence = 4,
    Web = 8,
    uPredict = 16,
    Pharaoh = 32,
    Messaging = 256,
    FdbPersistence = 32768,
    Primitives = 65536,
    All = Automation + Core + Persistence + Web + uPredict +Pharaoh + Messaging + FdbPersistence + Primitives
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::Automation = [PSCustomObject]@{ Git = "git@github.com:sensemaking/automation.git"; Directory = "~\automation"; Script = $null; VsSolution = $null; CodeSolution = "~\automation"; HasJs = $false; };
        [Project]::Core = [PSCustomObject]@{ Git = "git@github.com:sensemaking/core.git"; Directory = "~\core"; Script = $null; VsSolution = "~\core\Core.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Persistence = [PSCustomObject]@{ Git = "git@github.com:sensemaking/persistence.git"; Directory = "~\persistence"; Script = $null; VsSolution = "~\persistence\Persistence.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Web = [PSCustomObject]@{ Git = "git@github.com:sensemaking/web.git"; Directory = "~\web"; Script = $null; VsSolution = "~\web\.net\Web.sln"; CodeSolution = "~\web\js\core"; HasJs = $true; };        
        [Project]::uPredict = [PSCustomObject]@{ Git = "git@github.com:uPredict/uPredict.git"; Directory = "~\uPredict"; VsSolution = "~\uPredict\server\upredict.sln"; CodeSolution = "~\uPredict\client"; HasJs = $true; Script = $null; };
        [Project]::Pharaoh = [PSCustomObject]@{Directory = "~\fdb-rx-authoring"; HasJs = $true; CodeSolution = "~\fdb-rx-authoring\Pharaoh\UI\client"; VsSolution = "~\fdb-rx-authoring\Authoring.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-authoring.git"; ServerHost="~\fdb-rx-authoring\Pharaoh\UI\server\host" };
        [Project]::FdbPersistence = [PSCustomObject]@{Directory = "~\fdb-rx-persistence"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-persistence\Persistence.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-persistence.git" };
        [Project]::Messaging = [PSCustomObject]@{Directory = "~\fdb-rx-messaging"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-messaging\Messaging.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-messaging.git" };
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