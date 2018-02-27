function Ssh-SignIn{
    Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue
        
    & "ssh-agent.exe" | % {
        if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
            [void][Environment]::SetEnvironmentVariable($Matches['key'], $Matches['value'])
        }
    }

    & "ssh-add.exe" $env:USERPROFILE\.ssh\sm_rsa
}

function Status([Project] $project = [Project]::All){
    function Show-Status($targetProject){
        Write-Host `nStatus for $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git status . -s
    } 

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Show-Status $_ }
    Set-Location $dir
    Write-Host `n
}

function Pull ([Project] $project = [Project]::None){
    function Git-Pull($targetProject){
        Write-Host `nPulling $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git pull
    }

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Git-Pull $_ }
    Set-Location $dir
}

function Push ([Project] $project = [Project]::None, $message = "_"){
    function Git-Commit($targetProject){
        Write-Host Committing $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git pull
        git add .
        git commit -m $message --no-status
        git push
    }

    $dir = Get-Location 
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Git-Commit $_ }
    Set-Location $dir
}

function Revert ([Project] $project = [Project]::None){
    function Git-Revert($targetProject){
        Write-Host `nReverting $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git stash | git stash drop | git clean -qf
    }

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Git-Revert $_ }
    Set-Location $dir
}