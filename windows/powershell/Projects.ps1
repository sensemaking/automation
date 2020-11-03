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
    RxAuthoring = 64,
    All = Automation + Core + Persistence + Web + PopulationAnalytics + ContentAuthoring + RxAuthoring
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::Automation = [PSCustomObject]@{ Git = "git@github.com:sensemaking/automation.git"; Directory = "~\automation"; Script = $null; VsSolution = $null; CodeSolution = "~\automation"; HasJs = $false; };
        [Project]::Core = [PSCustomObject]@{ Git = "git@github.com:sensemaking/core.git"; Directory = "~\core"; Script = $null; VsSolution = "~\core\Core.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Persistence = [PSCustomObject]@{ Git = "git@github.com:sensemaking/persistence.git"; Directory = "~\persistence"; Script = $null; VsSolution = "~\persistence\Persistence.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::Web = [PSCustomObject]@{ Git = "git@github.com:sensemaking/web.git"; Directory = "~\web"; Script = $null; VsSolution = "~\web\.net\Web.sln"; CodeSolution = "~\web\js\core"; HasJs = $true; };        
        [Project]::PopulationAnalytics = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/population-analytics.git"; Directory = "~\population-analytics"; Script = $null; VsSolution = "~\population-analytics\PopulationAnalytics.sln"; CodeSolution = $null; HasJs = $false; };
        [Project]::ContentAuthoring = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-arx-content-authoring.git"; Directory = "~\fdb-arx-content-authoring"; Script = $null; VsSolution = "~\fdb-arx-content-authoring\ContentAuthoring.sln"; CodeSolution = "~\fdb-arx-content-authoring\Host\Ui\Web\src"; HasJs = $true; };
        [Project]::RxAuthoring = [PSCustomObject]@{ Git = "git@github.com:HearstHealthInternational/fdb-rx-authoring.git"; Directory = "~\fdb-rx-authoring"; Script = $null; VsSolution = "~\fdb-rx-authoring\Authoring.sln"; CodeSolution = $null; HasJs = $false; };
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