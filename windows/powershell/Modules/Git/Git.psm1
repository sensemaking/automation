function Ssh-SignIn{
    Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue
        
    & "$env:programFiles\Git\usr\bin\ssh-agent.exe" | % {
        if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
            [void][Environment]::SetEnvironmentVariable($Matches['key'], $Matches['value'])
        }
    }

    & "$env:programFiles\Git\usr\bin\ssh-add.exe" $env:USERPROFILE\.ssh\sm_rsa
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

function Pull ([Project] $project = [Project]::None){
    function Git-Pull($targetProject){
        Write-Host `nPulling $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git pull
    }

    Status $project

    $dir = Get-Location
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Git-Pull $_ }
    Write-Host `n
    Set-Location $dir
}

function Push ([Project] $project = [Project]::None, $message){
    function Git-Commit($targetProject){
        Write-Host `nCommitting $targetProject.Key -Fore Green
        Set-Location $targetProject.Value.Directory
        git add .
        git commit -m $message --no-status
        git push
    }

    Status $project

    $dir = Get-Location 
    (Get-Projects).GetEnumerator() | Where-Object { $project.HasFlag($_.Key) } | % { Git-Commit $_ }
    write-host `n
    Set-Location $dir
}
