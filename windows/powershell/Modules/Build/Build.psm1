
function GoTo ([Project] $project) {
    if ($project -eq [Project]::None) {
        Write-Host "`nNo project provided`n" -Fore Red
        return
    }
    if ($project -eq [Project]::All) {
        Write-Host "`nCan't go to 'All' projects`n" -Fore Red
        return
    }
    Set-Location (Get-Project $project).Value.Directory
}

function Prime ([Project] $project) {
    function Prime-Project($targetProject) {
        if (-not(Test-Path "$($_.Value.Directory)")) { Clone $targetProject.key }
        else { pull $targetProject.Key }
            
        if (Test-Path "$($_.Value.Directory)\primer.ps1") {
            Write-Host "`nRunning $($targetProject.Key) Primer`n" -ForegroundColor Green
            & "$($_.Value.Directory)\primer.ps1"
            Write-Host "`n$($targetProject.Key) Primed & Ready To Go`n" -ForegroundColor Green
        }
        else { Write-Host "`n$($targetProject.Key) does not have a primer`n" -ForegroundColor Red }

        Build $targetProject.Key
    }

    Get-Project $project | % { Prime-Project $_ }
}

function Open ([Project] $project = [Project]::None, [Switch] $clientOnly, [Switch] $serverOnly) {
    function Open-Project($targetProject) {
        $dir = Get-Location
        Set-Location $_.Value.Directory     
        
        git pull
        BreakOnFailure $dir '**************** Pull Failed ****************'

        if ($null -ne $_.Value.VsSolution -and -not $clientOnly) { 
            & $_.Value.VsSolution 
        } 

        if ($null -ne $_.Value.CodeSolution -and -not $serverOnly) { 
            $dir = Get-Location
            Set-Location $_.Value.CodeSolution  
            code . 
        }

        Set-Location $dir
    }

    Clear-Host
    Get-Project $project | % { Open-Project $_ }
}

function Build ([Project] $project = [Project]::All, [Switch] $clientOnly, [Switch] $serverOnly) {
    function Build-Project($targetProject) {
        $dir = Get-Location
        Set-Location $_.Value.Directory         

        git pull
        BreakOnFailure $dir '**************** Pull Failed ****************'

        if ($null -ne $_.Value.VsSolution -and -not $clientOnly) { 
            Write-Host `nBuilding $targetProject.Key -Fore Green
            $solutionPath = Resolve-Path ($_.Value.VsSolution)            
            dotnet build $solutionPath --configuration Release -nologo --verbosity q --no-incremental 
            BreakOnFailure $dir '**************** Build Failed ****************'
            Migrate $targetProject.Key
            Write-Host `nRunning Tests`n -Fore Green
            dotnet test $solutionPath -m:1 --filter FullyQualifiedName!~Smokes --no-build --no-restore --nologo --verbosity m
            BreakOnFailure $dir '**************** Tests Failed ****************'
        }         

        if ($null -ne $_.Value.CodeSolution -and -not $serverOnly) {
            Write-Host `nBuilding JavaScript $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.CodeSolution         
            yarn
            yarn test
            BreakOnFailure $dir '**************** Javascript Build Failed ****************'
        } 

        Set-Location $dir
    }

    Get-Project $project | % { Build-Project $_ }
    Write-Host `n**************** Build was successful ****************`n -Fore Green
}

function Migrate ([Project] $project = [Project]::All) {
    function Migrate-Project($targetProject) {
        if ($null -ne $_.Value.VsSolution) { 
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

    Get-Project $project | % { Migrate-Project $_ }
}
    
function Run-Client([Project] $project = [Project]::All) {
    function Run($targetProject) {
        if ($null -ne $_.Value.CodeSolution) {
            Write-Host `nRunning $targetProject.Key client `n -Fore Green     
            Set-Location $_.Value.CodeSolution    
            yarn start            
        }
    }

    Clear-Host
    Get-Project $project | % { Run $_ }
}

function Run-Server([Project] $project = [Project]::All) {
    function Run($targetProject) {
        if ($null -ne $_.Value.ServerHost) {
            if (!(Get-Process CosmosDB.Emulator -ErrorAction SilentlyContinue)) { CosmosDB.Emulator.exe /NoUi /PartitionCount=50 /NoExplorer /DefaultPartitionCount=50 }
            Write-Host `nRunning $targetProject.Key server `n -Fore Green
            Set-Location $_.Value.ServerHost
            dotnet watch run --urls https://localhost:5001
        }
    }

    Clear-Host
    Get-Project $project | % { Run $_ }
}

function Lint([Project] $project = [Project]::All) {
    function Lint($targetProject) {
        if ($null -ne $_.Value.CodeSolution) {
            Write-Host `nLinting JavaScript $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.CodeSolution    
            yarn lint
            Set-Location $dir
        }
    }

    Clear-Host
    Get-Project $project | % { Lint $_ }
}


function Watch([Project] $project = [Project]::All) {
    function Watch-Project($targetProject) {
        if ($null -ne $_.Value.CodeSolution) {
            Write-Host `nWatching JavaScript $targetProject.Key `n -Fore Green     
            Set-Location $_.Value.CodeSolution    
            yarn watch
            Set-Location $dir
        }
    }

    Clear-Host
    Get-Project $project | % { Watch-Project $_ }
}

function BreakOnFailure([string] $directory, [string] $message = 'It failed!') {
    if ($lastexitcode -ne 0) {
        Write-Host `n $message`n -Fore Red
        Set-Location $directory
        break
    }
}