function AssociateFileExtensions ($Extensions, $OpenAppPath){
    $Extensions | % {
        $fileType = (cmd /c "assoc $_").Split("=")[-1]
        cmd /c "ftype $fileType=""$OpenAppPath"" ""%1"""
    }
}

AssociateFileExtensions .txt,.ps1,.psm1,.js "$env:programFiles\Microsoft VS Code\Code.exe"

$email = read-host `nPlease enter your email address

write-host "`nCreate a personal access token on github with read:packages permission" -fore yellow
$token = read-host `nPlease enter your personal access token here
$username = read-host `nPlease enter your GitHub username
            
dotnet nuget add source https://nuget.pkg.github.com/sensemaking/index.json -n Sensemaking -u $username -p $token --store-password-in-clear-text

git config --global user.name $email
git config --global user.email $email

& "~\automation\windows\$email\win10_configure.ps1"
& "~\automation\windows\$email\VSCode\extensions.ps1"

Copy-Item "~\automation\windows\$email\VSCode\*.json" "$env:userprofile\AppData\Roaming\Code\User"
Copy-Item "~\automation\windows\$email\Shell\ConEmu.xml" "$env:userprofile\AppData\Roaming"

Restart-Computer