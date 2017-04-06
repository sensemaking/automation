function Ssh-SignIn{
    Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue
        
    & "$env:programFiles\Git\usr\bin\ssh-agent.exe" | % {
        if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
            [void][Environment]::SetEnvironmentVariable($Matches['key'], $Matches['value'])
        }
    }

	& "$env:programFiles\Git\usr\bin\ssh-add.exe" $env:USERPROFILE\.ssh\sm_rsa
}

function Checkout ($branch, [Project] $project = [Project]::All){
    function Git-Checkout($targetProject){
        Set-Location $targetProject.Value.Directory
        git checkout $branch -q
    }

    Status $project
    Write-Host "Do you want to continue (Y/N)?" -Fore Yellow 
    if((Read-Host) -eq 'Y'){
        $dir = Get-Location
        (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Git-Checkout $_ }
        Branches $project
        Set-Location $dir
    }
}

function Pull ([Project] $project = [Project]::All){
    function Git-Pull($targetProject){
        Write-Host `nPulling $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git pull
    }

    Status $project
    Write-Host "Do you want to continue (Y/N)?" -Fore Yellow 
    if((Read-Host) -eq 'Y'){
        $dir = Get-Location
        (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Git-Pull $_ }
        Write-Host `n
        Set-Location $dir
    }
}
	
function Status([Project] $project = [Project]::All){
    function Show-Status($targetProject){
            Write-Host `nStatus for $targetProject.Key -Fore Green
            Set-Location $targetProject.Value.Directory
            git status -s
    } 

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Show-Status $_ }
    Write-Host `n
    Set-Location $dir
}
	
function Branches([Project] $project = [Project]::All){
    function Show-Branch($targetProject){
            Write-Host `nBranches for $targetProject.Key -Fore Green
            Set-Location $targetProject.Value.Directory
            git branch
    } 

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Show-Branch $_ }
    Write-Host `n
    Set-Location $dir
}

function New-Branch($branch, [Project] $project = [Project]::All){
    function Create-Branch($targetProject){
            Write-Host `nCreating $branch for $targetProject.Key -Fore Green
            Set-Location $targetProject.Value.Directory
            git checkout -b $branch
            git push -u origin $branch
    } 

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Create-Branch $_ }
    Write-Host `n
    Set-Location $dir
}

function Commit ($message, [Project] $project = [Project]::All){
    function Git-Commit($targetProject){
        Write-Host `nCommitting $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git add .
        git commit -m $message --no-status
        git push
    }

    Status $project
    Write-Host "Do you want to continue (Y/N)?" -Fore Yellow 
    if((Read-Host) -eq 'Y'){
        $dir = Get-Location 
        (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Git-Commit $_ }
        write-host `n
        Set-Location $dir
    }
}
