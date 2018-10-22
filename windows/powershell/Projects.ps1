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
    if($project -eq [Project]::None){
        Write-Host "`nNo project provided`n" -Fore Red
        return
    }
    if($project -eq [Project]::All){
        Write-Host "`nCan't go to 'All' projects`n" -Fore Red
        return
    }
    Invoke-Item (Get-Projects).Get_Item($project).Directory
}

function global:Prime ([Project] $project){
    function Prime-Project($targetProject){
            if(Test-Path "$($_.Value.Directory)\primer.ps1") {
                Write-Host "`nRunning $project Primer" -ForegroundColor Green
                & "$($_.Value.Directory)\primer.ps1"
                Write-Host "`n$project Primed & Ready To Go" -ForegroundColor Green
            }
            else{
                Write-Host "`n$project does not have a primer`n" -ForegroundColor Red
            }
    }

    (Get-Projects).GetEnumerator() | Where{ $project.HasFlag($_.Key) } | % { Prime-Project $_ }
}

function global:Open ([Project] $project = [Project]::None){
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

function global:Build ([Project] $project = [Project]::All){
    function Build-Project($targetProject){
        if ($_.Value.VsSolution -ne $null) { 
            Write-Host `nBuilding $targetProject.Key `n -Fore Green
            nuget.exe restore (Resolve-Path ($_.Value.VsSolution)) -v quiet
            MSBuild.exe (Resolve-Path ($_.Value.VsSolution)) /p:Config=Release /p:TreatWarningsAsErrors=true /v:quiet 
            Migrate $targetProject.Key
            Test $targetProject.Key
        } 
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Build-Project $_ }
}

function global:Migrate ([Project] $project = [Project]::All){
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

function global:Test ([Project] $project = [Project]::All){
    function Test-Project($targetProject){
        if ($_.Value.VsSolution -ne $null) { 
            Write-Host `nRunning Tests $targetProject.Key `n -Fore Green
            $dir = Get-Location
            Set-Location $_.Value.Directory
            nunit3-console.exe (Get-ChildItem *Testing*.dll -Recurse | Where-Object { $_.FullName -notlike '*obj*' }) --noresult --noheader
            Set-Location $dir
        } 
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Test-Project $_ }
}
