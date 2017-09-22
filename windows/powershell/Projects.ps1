Add-Type -TypeDefinition @"
[System.Flags]
public enum Project
{
    None = 0,
    Automation = 1,
    All = Automation + 2
}
"@

function global:Get-Projects {
    return @{ 
        [Project]::Automation = [PSCustomObject]@{ Directory = "~\automation"; CodeSolution = "~\automation"; VsSolution = $null; Script = $null }; 
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

function global:Build ([Project] $project){
    function Build-Project($targetProject){
        if ($_.Value.VsSolution -ne $null) { 
            Write-Host `nBuilding $targetProject.Key `n -Fore Green
            nuget.exe restore (Resolve-Path ($_.Value.VsSolution))
            MSBuild.exe (Resolve-Path ($_.Value.VsSolution)) /p:Config=Release /v:quiet
        } 
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Build-Project $_ }
    Migrate $project
    Test $project
}

function global:Migrate ([Project] $project){
    function Migrate-Project($targetProject){
        if ($_.Value.VsSolution -ne $null) { 
            $solutionPath = (Split-Path($_.Value.VsSolution))
            if(Test-Path("$solutionPath\Migrations")){
                Write-Host `nRunning Migrations $targetProject.Key `n -Fore Green
                & (Resolve-Path $solutionPath\Migrations\bin\Run.exe)
            }
        } 
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Migrate-Project $_ }
}

function global:Test ([Project] $project){
    function Test-Project($targetProject){
        if ($_.Value.VsSolution -ne $null) { 
            Write-Host `nRunning Tests $targetProject.Key `n -Fore Green
            $dir = Get-Location
            Set-Location $_.Value.Directory
            nunit3-console.exe (Get-ChildItem *Testing*.dll -Recurse | Where-Object { $_.FullName -notlike '*obj*' }) --noresult
            Set-Location $dir
        } 
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Test-Project $_ }
}
