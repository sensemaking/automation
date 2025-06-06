Add-Type -TypeDefinition @"
public enum Project
{
    All,
    None,
    Automation,
    Core,
    Persistence,
    Web,
    Trnk,
    LeadsAndAi
}
"@

function global:Get-Project ([Project] $project = [Project]::All) {
    $projects = @{ 
        [Project]::Automation      = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/automation.git"; 
            Directory    = "~\automation"; 
            CodeSolution = "~\automation"; 
        };
        [Project]::Core            = [PSCustomObject]@{ 
            Git        = "git@github.com:sensemaking/core.git"; 
            Directory  = "~\core"; 
            VsSolution = "~\core\Core.sln"; 
        };
        [Project]::Persistence     = [PSCustomObject]@{ 
            Git        = "git@github.com:sensemaking/persistence.git"; 
            Directory  = "~\persistence"; 
            VsSolution = "~\persistence\Persistence.sln"; 
        };
        [Project]::Web             = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/web.git"; 
            Directory    = "~\web";
            VsSolution   = "~\web\.net\Web.sln"; 
            CodeSolution = "~\web\js\core"; 
        };        
        [Project]::Trnk = [PSCustomObject]@{
            Git        = "git@github.com:sensemaking/trnk.git"; 
            Directory  = "~\trnk";          
            CodeSolution = "~\trnk";    
        };
        [Project]::LeadsAndAi = [PSCustomObject]@{
            Git        = "git@github.com:sensemaking/leadsandai.git"; 
            Directory  = "~\leadsandai";          
            CodeSolution = "~\leadsandai";    
        };
    }

    return $projects.GetEnumerator() | Where-Object { $project -eq $_.Key -or $project -eq [Project]::All } 
}

function global:Update-Projects { 
    $automationDir = (Get-Project Automation).Value.Directory 
    $profileDir = Split-Path $PROFILE
   
    if (!(Test-Path $automationDir)) { clone Automation }

    pull Automation
 
    Copy-Item "$automationDir\windows\powershell\Projects.ps1" -Destination "$profileDir\Projects.ps1" -fo
    Write-Host "`nUpdated projects. Reloading shell`n" -Fore Green
    powershell.exe -nologo
}