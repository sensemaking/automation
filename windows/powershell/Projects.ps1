Add-Type -TypeDefinition @"
public enum Project
{
    All,
    None,
    Documents,
    Automation,
    Core,
    Persistence,
    Web,
    SenseMaking,
    uPredict,
    SensibleCopilot,
    GroceryManager
}
"@

function global:Get-Project ([Project] $project = [Project]::All) {
    $projects = @{ 
        [Project]::Documents       = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/documents.git"; 
            Directory    = "~\docs"; 
            NoBuild      = $true; 
            CodeSolution = "~\docs"; 
        };
        [Project]::SensibleCopilot = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/sensible-copilot.git"; 
            Directory    = "~\sensible-copilot"; 
            NoBuild      = $true; 
            CodeSolution = "~\sensible-copilot"; 
        };
        [Project]::Automation      = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/automation.git"; 
            Directory    = "~\automation"; 
            NoBuild      = $true; 
            CodeSolution = "~\automation"; 
        };
        [Project]::Core            = [PSCustomObject]@{ 
            Git        = "git@github.com:sensemaking/core.git"; 
            Directory  = "~\core"; 
            VsSolution = "~\core\Core.sln"; 
        };
        [Project]::Persistence     = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/persistence.git"; 
            Directory    = "~\persistence"; 
            VsSolution   = "~\persistence\Persistence.sln"; 
            ElevateTests = $true; 
        };
        [Project]::Web             = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/web.git"; 
            Directory    = "~\web";
            VsSolution   = "~\web\.net\Web.sln"; 
            CodeSolution = "~\web\js\core"; 
        };        
        [Project]::SenseMaking     = [PSCustomObject]@{ 
            Git          = "git@github.com:sensemaking/sensemaking.github.io.git"; 
            Directory    = "~\sm-website";            
            CodeSolution = "~\sm-website"; 
        };
        [Project]::uPredict        = [PSCustomObject]@{ 
            Git          = "git@github.com:uPredict/uPredict.git"; 
            Directory    = "~\upredict";            
            CodeSolution = "~\upredict\client";
            VsSolution   = "~\upredict\server\upredict.sln"; 
        };
        [Project]::GroceryManager  = [PSCustomObject]@{ 
            Git          = "git@github.com:davewil/grocery_planner.git"; 
            Directory    = "~\grocery_planner";            
            CodeSolution = "~\grocery_planner";
            NoBuild      = $true; 
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
    pwsh.exe -nologo
}
