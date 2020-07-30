function AssociateFileExtensions ($Extensions, $OpenAppPath){
    $Extensions | % {
        $fileType = (cmd /c "assoc $_").Split("=")[-1]
        cmd /c "ftype $fileType=""$OpenAppPath"" ""%1"""
    }
}

AssociateFileExtensions .txt,.ps1,.psm1.psd1,.js,.json "$env:programFiles\Microsoft VS Code\Code.exe"

$email = read-host `nPlease enter your email address

write-host "`nCreate a personal access token on github with all repo, and :packages permissions" -fore yellow
$token = read-host `nPlease enter your personal access token here
$username = read-host `nPlease enter your GitHub username
            
dotnet nuget add source https://nuget.pkg.github.com/sensemaking/index.json -n Sensemaking -u $username -p $token --store-password-in-clear-text

git config --global user.name $email
git config --global user.email $email

& ".\$email\VSCode\extensions.ps1"

Copy-Item ".\$email\VSCode\*.json" "$env:userprofile\AppData\Roaming\Code\User"

Restart-Computer

