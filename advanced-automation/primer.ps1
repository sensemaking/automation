$smRoot = "C:\projects"
mkdir $smRoot -force

$doInitialSetup = read-host `nInstall Chocolately, Git and Setup SSH?
if($doInitialSetup.StartsWith("y","CurrentCultureIgnoreCase")) {
    write-host "`nInstalling chocolatey" -fore yellow
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

    choco install git nodejs yarn visualstudio2017professional nuget.commandline vscode azure-cosmos-db-emulator -yr

    write-host "`nSetting up ssh" -fore yellow
    $env:path += ";$env:programFiles\Git\bin;$env:programFiles\Git\cmd;$env:programFiles\Git\usr\bin;"
    $sshDirectory = "$env:userprofile\.ssh"
    mkdir $sshdirectory -force
    ssh-keygen -f "$sshdirectory\sm_rsa"

    write-host "`n$sshdirectory\sm_rsa.pub has been generated" -fore green
    write-host "`nAdd the key to your github account" -fore red 
    read-host "`n`nThen press any key"

    Set-Location $smRoot
    & "$env:programFiles\Git\usr\bin\ssh-agent.exe" | ForEach-Object {
            if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
                [void][Environment]::SetEnvironmentVariable($Matches['key'], $Matches['value'])
            }
        }
    ssh-add "$sshdirectory\sm_rsa"
    Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue
}

Write-Host `nUpdating Git Module
mkdir (Join-Path (Split-Path $PROFILE) "Modules\Git\") -fo
Copy-Item "./Git.psm1" -Destination (Join-Path (Split-Path $PROFILE) "Modules\Git\Git.psm1") -fo

Write-Host `nUpdating Web Module
mkdir (Join-Path (Split-Path $PROFILE) "Modules\Web\") -fo
Copy-Item "./Web.psm1" -Destination (Join-Path (Split-Path $PROFILE) "Modules\Web\Web.psm1") -fo

Write-Host `nUpdating Web Module
mkdir (Join-Path (Split-Path $PROFILE) "Modules\Build\") -fo
Copy-Item "./Build.psm1" -Destination (Join-Path (Split-Path $PROFILE) "Modules\Build\Build.psm1") -fo

Write-Host `nUpdating Projects
Copy-Item "./ArxProjects.ps1" -Destination (Join-Path (Split-Path $PROFILE) "Projects.ps1") -fo

Write-Host `nRemoving Orx Module
Remove-Item (Join-Path (Split-Path $PROFILE) "Modules\ORx\") -fo -r -ErrorAction Ignore

If((Test-Path (Join-Path (Split-Path $PROFILE) "AddEnvironmentPaths.ps1")) -eq $False) {
    Write-Host `nProviding Initial Environment Paths (you may need to edit these)
    Copy-Item "./DefaultEnvironmentPaths.ps1" -Destination (Join-Path (Split-Path $PROFILE) "AddEnvironmentPaths.ps1") -fo
}

Write-Host `nOverwriting Profile
Copy-Item $PROFILE -Destination "$PROFILE.backup" -fo
Copy-Item "./profile.ps1" -Destination $PROFILE -fo

write-host "`nRestart powershell [Win+x, A]"
