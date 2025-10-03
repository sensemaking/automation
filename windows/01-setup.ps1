$smRoot = read-host `nPlease enter the path you want to be the sensemaking root
mkdir $smRoot -force

sudo config --enable normal

write-host "`nInstalling chocolatey" -fore yellow
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install brave -yr
choco install git -yr

Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent

git config --global user.name "$userName"
git config --global user.email $userEmail
git config --global core.sshCommand C:/Windows/System32/OpenSSH/ssh.exe

Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent

git config --global user.name "$userName"
git config --global user.email $userEmail
git config --global rebase.autoStash true

git config --global core.sshCommand C:/Windows/System32/OpenSSH/ssh.exe
ssh-keygen -t ed25519 -C $userEmail

$sshKeyPath = Resolve-Path $env:USERPROFILE\.ssh\id_ed25519
ssh-add $sshKeyPath

Get-Content ~\.ssh\id_ed25519.pub | Set-Clipboard 
Write-Host "`nYour public key has been copied to your clipboard you can now add it to your SSH keys on GitHub"
Start-Process "https://github.com/settings/keys"

Read-Host "`nPress any key to continue once you have added the key to GitHub"
ssh-keygen -t ed25519 -C $userEmail
$sshKeyPath = Resolve-Path ~\.ssh\id_ed25519
ssh-add $sshKeyPath

Get-Content ~\.ssh\id_ed25519.pub | Set-Clipboard 
Write-Host "`nYour public key has been copied to your clipboard you can now add it to your SSH keys on GitHub"

Read-Host "`nPress any key to continue once you have added the key to GitHub"
write-host "`n$sshdirectory\id_rsa.pub has been generated" -fore green
write-host "`nAdd the key to your github account" -fore red 
read-host "`n`nThen press any key"

Set-Location $smRoot
& "$env:programFiles\Git\usr\bin\ssh-agent.exe" | % {
    if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
        [void][Environment]::SetEnvironmentVariable($Matches['key'], $Matches['value'])
    }
}
& "$env:programFiles\Git\usr\bin\ssh-add" "$sshdirectory\id_rsa"

git clone git@github.com:sensemaking/automation.git
Stop-Process -Name 'ssh-agent' -ErrorAction SilentlyContinue

Copy-Item "$smroot\automation\windows\powershell\*" (split-path $PROFILE) -r

$content = { (Get-Content "$smRoot\automation\windows\powershell\Microsoft.PowerShell_profile.ps1") }.Invoke()
$content.Insert(0, "`$smHome = `"$smRoot`"") 
$content | Set-Content $PROFILE

write-host "`nSetup Complete. Please edit Project.ps1 found at (Split-Path $PROFILE)" -fore green

refreshEnv
& $PROFILE
write-host "Please run .\automation\windows\clean.ps1"
