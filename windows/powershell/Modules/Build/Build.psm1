
function GoTo ([Project] $project){
    if($project -eq [Project]::None){
        Write-Host "`nNo project provided`n" -Fore Red
        return
    }
    if($project -eq [Project]::All){
        Write-Host "`nCan't go to 'All' projects`n" -Fore Red
        return
    }
    Set-Location (Get-Projects).Get_Item($project).Directory
}

function Prime ([Project] $project){
    function Prime-Project($targetProject){
            if(Test-Path "$($_.Value.Directory)\primer.ps1") {
                Write-Host "`nRunning $($targetProject.Key) Primer" -ForegroundColor Green
                & "$($_.Value.Directory)\primer.ps1"
                Write-Host "`n$($targetProject.Key) Primed & Ready To Go`n" -ForegroundColor Green
            }
            else{
                Write-Host "`n$($targetProject.Key) does not have a primer`n" -ForegroundColor Red
            }
    }

    (Get-Projects).GetEnumerator() | Where{ $project.HasFlag($_.Key) } | % { Prime-Project $_ }
}

function Open ([Project] $project = [Project]::None, [Switch] $noBuild){
    function Open-Project($targetProject){
       
        if (!$noBuild) { Build $targetProject.Key }

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

function Build ([Project] $project = [Project]::All){
    function Build-Project($targetProject){
        $dir = Get-Location
        Set-Location $_.Value.Directory         

        git pull
        BreakOnFailure $dir '**************** Pull Failed ****************'

        if ($_.Value.VsSolution -ne $null) { 
            Write-Host `nBuilding .NET $targetProject.Key `n -Fore Green
            $solutionPath = Resolve-Path ($_.Value.VsSolution)
            dotnet build --configuration Release -nologo
            BreakOnFailure $dir '**************** Build Failed ****************'
        }         

        if ($_.Value.HasJs) {
            Write-Host `nBuilding JavaScript $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.CodeSolution         
            yarn          
            yarn run static:build
            BreakOnFailure $dir '**************** Javascript Build Failed ****************'
        }

        if($_.Value.VsSolution -ne $null -Or $_.Value.CodeSolution -ne $null) {
            Migrate $targetProject.Key
            Test $targetProject.Key
        }

        Set-Location $dir
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Build-Project $_ }
    Write-Host `n**************** Build was successful ****************`n -Fore Green
}

function Migrate ([Project] $project = [Project]::All){
    function Migrate-Project($targetProject){
        if ($_.Value.VsSolution -ne $null) { 
            $dir = Get-Location
            Set-Location $_.Value.Directory
            Get-ChildItem .\ -Recurse | where { $_.Fullname -Like "*bin\Run.exe" } | % {      
                Write-Host `nRunning Migrations $targetProject.Key - $_.FullName`n -Fore Green
                & (Resolve-Path $_.FullName)
                BreakOnFailure $dir 'Migrations Failed'
            }
            Set-Location $dir
        } 
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Migrate-Project $_ }
}

function Test ([Project] $project = [Project]::All){
    function Test-Project($targetProject){
        $dir = Get-Location

        if ($_.Value.VsSolution -ne $null) { 
            Write-Host `nRunning .NET Tests $targetProject.Key `n -Fore Green
            Set-Location $_.Value.Directory
            nunit3-console.exe (Get-ChildItem *Specs*.dll -Recurse | Where-Object { $_.FullName -notlike '*obj*' -and $_.FullName -notlike '*Builders*'}) --noresult --noheader
            BreakOnFailure $dir 'Testing Failed'
        }
        
        if ($_.Value.HasJs) {
            Write-Host `nRunning JavaScript Tests $targetProject.Key `n -Fore Green
            $dir = Get-Location
            Set-Location $_.Value.CodeSolution
            yarn run static:test
            BreakOnFailure $dir 'Javascript Testing Failed'
        }

        Set-Location $dir
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Test-Project $_ }
}

function Watch([Project] $project = [Project]::All) {
    function Watch-Project($targetProject){
        if ($_.Value.CodeSolution -ne $null) {
            Write-Host `nWatching JavaScript $targetProject.Key `n -Fore Green     
            $dir = Get-Location
            Set-Location $_.Value.CodeSolution    
            yarn start
            Set-Location $dir
        }
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Watch-Project $_ }
}

function BreakOnFailure([string] $directory, [string] $message = 'It failed!'){
    if ($lastexitcode -ne 0) {
        Write-Host `n $message`n -Fore Red
        Set-Location $directory
        break
    }
}