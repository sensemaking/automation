
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
            if(-not(Test-Path "$($_.Value.Directory)")) { Clone $project }
            else{ pull $targetProject.Key }
            
            if(Test-Path "$($_.Value.Directory)\primer.ps1") {
                Write-Host "`nRunning $($targetProject.Key) Primer`n" -ForegroundColor Green
                & "$($_.Value.Directory)\primer.ps1"
                Write-Host "`n$($targetProject.Key) Primed & Ready To Go`n" -ForegroundColor Green
            }
            else{ Write-Host "`n$($targetProject.Key) does not have a primer`n" -ForegroundColor Red }
    }

    (Get-Projects).GetEnumerator() | Where{ $project.HasFlag($_.Key) } | % { Prime-Project $_ }
}

function Open ([Project] $project = [Project]::None, [Switch] $frontEndOnly){
    function Open-Project($targetProject){
        $dir = Get-Location
        Set-Location $_.Value.Directory     
        
        git pull
        BreakOnFailure $dir '**************** Pull Failed ****************'

        if ($null -ne $_.Value.VsSolution -and -not $frontEndOnly) { 
            & $_.Value.VsSolution 
        } 

        if ($_.Value.CodeSolution -ne $null) { 
            $dir = Get-Location
            Set-Location $_.Value.CodeSolution  
            code . 
        }

        Set-Location $dir
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
            Write-Host `nBuilding $targetProject.Key -Fore Green
            $solutionPath = Resolve-Path ($_.Value.VsSolution)
            dotnet restore $solutionPath --verbosity q
            dotnet build $solutionPath --configuration Release -nologo --verbosity q -warnAsError --no-incremental --no-restore
            BreakOnFailure $dir '**************** Build Failed ****************'
            Migrate $targetProject.Key
            Write-Host `nRunning Tests`n -Fore Green
            dotnet test $solutionPath --filter FullyQualifiedName!~Smokes --no-build --no-restore --nologo --verbosity q 
            BreakOnFailure $dir '**************** Tests Failed ****************'
        }         

        if ($_.Value.HasJs) {
            Write-Host `nBuilding JavaScript $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.CodeSolution         
            yarn
            yarn build 
            yarn test
            BreakOnFailure $dir '**************** Javascript Build Failed ****************'
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
                Write-Host `nRunning Migrations - $_.FullName`n -Fore Green
                & (Resolve-Path $_.FullName)
                BreakOnFailure $dir 'Migrations Failed'
            }
            Set-Location $dir
        } 
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Migrate-Project $_ }
}
    
function Run-Client([Project] $project = [Project]::All) {
    function Run($targetProject){
        if ($_.Value.CodeSolution -ne $null) {
            Write-Host `nRunning $targetProject.Key client `n -Fore Green     
            Set-Location $_.Value.CodeSolution    
            yarn start            
        }
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Run $_ }
}

function Run-Server([Project] $project = [Project]::All) {
    function Run($targetProject) {
        if ($_.Value.VsSolution -ne $null) {
            Write-Host `nRunning $targetProject.Key server `n -Fore Green
            Set-Location "$_.Value.Directory\Server\Host"
            dotnet watch run --urls http://localhost:5001
        }
    }

    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Run $_ }
}

function Watch([Project] $project = [Project]::All) {
    function Watch-Project($targetProject){
        if ($_.Value.CodeSolution -ne $null) {
            Write-Host `nWatching JavaScript $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.CodeSolution    
            yarn watch
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