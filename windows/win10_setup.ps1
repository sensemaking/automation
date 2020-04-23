$smRoot = read-host `nPlease enter the path you want to be the sensemaking root
mkdir $smRoot -force

write-host "`nInstalling chocolatey" -fore yellow
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install git -yr

write-host "`nSetting up ssh" -fore yellow
$env:path += ";$env:programFiles\Git\bin;$env:programFiles\Git\cmd;$env:programFiles\Git\usr\bin;"
$sshDirectory = "$env:userprofile\.ssh"
mkdir $sshdirectory -force
ssh-keygen -f "$sshdirectory\sm_rsa"

write-host "`n$sshdirectory\sm_rsa.pub has been generated" -fore green
write-host "`nAdd the key to your github account" -fore red 
read-host "`n`nThen press any key"

Set-Location $smRoot
& "$env:programFiles\Git\usr\bin\ssh-agent.exe" | % {
        if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
            [void][Environment]::SetEnvironmentVariable($Matches['key'], $Matches['value'])
        }
    }
ssh-add "$sshdirectory\sm_rsa"
git clone git@github.com:sensemaking/automation.git
Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue

Copy-Item "$smroot\automation\windows\powershell\*" (split-path $PROFILE) -r

$content = {(Get-Content "$smRoot\automation\windows\powershell\Microsoft.PowerShell_profile.ps1")}.Invoke()
$content.Insert(0, "`$smHome = `"$smRoot`"") 
$content | Set-Content $PROFILE

write-host "`nSetup Complete. Please edit Project.ps1 found at (Split-Path $PROFILE)" -fore green

refreshEnv
& $PROFILE
write-host "Please run .\automation\windows\win10_clean.ps1"
