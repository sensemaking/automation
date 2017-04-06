Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None = 0,
    ProjectName = 1,
    All = ProjectName
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::ProjectName = [PSCustomObject]@{ 
            Directory = ""; 
            CodeSolution = $null; 
            VsSolution = $null; 
            Script = $null
        }; 
    }
}

function global:GoTo ([Project] $project){
    if($project -eq [Project]::All){
        Write-Host "`nCan't go to 'All' projects`n" -Fore Red
        return
    }
    Set-Location (Get-Projects).Get_Item($project).Directory
}

function global:Open ([Project] $project){
    function Open-Project($targetProject){
        if ($_.Value.VsSolution -ne $null) { 
            & $_.Value.VsSolution 
        } 

        if ($_.Value.CodeSolution -ne $null) { 
            $dir = Get-Location
            Set-Location $_.Value.CodeSolution  
            code . 
            Set-Location $dir
        }
    }

    (Get-Projects).GetEnumerator() | Where{ $project.HasFlag($_.Key) } | % { Open-Project $_ }
}