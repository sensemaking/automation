Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1

function Add-LocalDb($dbName, $location){
    if((SqlLocalDB.exe info) -contains $dbName) {
        SqlLocalDB.exe stop $dbName 
        SqlLocalDB.exe delete $dbName 
    }
    
    SqlLocalDB.exe create $dbName
    SqlLocalDB.exe start $dbName
    SqlLocalDB.exe share $dbName $dbName

    Remove-Item $location -r -for -ErrorAction SilentlyContinue 
    mkdir $location > $null
    SQLCMD.exe -S "(localdb)\$dbName" -E -Q "if(db_id('$dbName') is null) create database $dbName on ( NAME=$dbName, FILENAME = '$location\$dbName.mdf' ) log on ( NAME=${dbName}Log, FILENAME = '$location\$dbName.ldf' )"
    
    SqlLocalDB.exe stop $dbName
}

function Add-ReactApp($path){
    mkdir $path\client
    npx create-react-app $path\client --template typescript
    rm $path\client\public\* -r -for
    rm $path\client\src\* -r -for
    rm $path\client\README.md -for    
    rm $path\client\.gitignore -for    
    $dir = Get-Location
    Set-Location $path\client
    yarn remove web-vitals
    Set-Location $dir
}
 
function Add-Site($name, $port, $path, $hostName){
    Remove-Website $name -ErrorAction SilentlyContinue
    Remove-WebAppPool $name -ErrorAction SilentlyContinue
    Remove-Certificate $name
    
    Add-Host $hostName
    Add-AppPool $name
    New-Website -Name $name -Port $port -PhysicalPath $path -ApplicationPool $name -HostHeader $hostName | Out-Null
    Enable-Tls $name $hostName
}

function Add-Host($hostName, $ip = "127.0.0.1") {
    "`r`n$ip`t$hostName" | Out-File C:\Windows\System32\drivers\etc\hosts -Append -NoNewLine -Encoding ascii
}

function Add-AppPool($name) {    
    $appPool = New-WebAppPool $name -force
    $appPool.processModel.identityType = 0
    $appPool.managedRuntimeVersion = "v4.0"
    $appPool | Set-Item
}

function Enable-Tls($name, $hostName) {    
    New-WebBinding -Name $name -IP "*" -Port "443" -Protocol https -HostHeader $hostName 
    $cert = New-SelfSignedCertificate -DnsName $name -CertStoreLocation "cert:\LocalMachine\My"
    (Get-WebBinding -Name $name -Protocol https).AddSslCertificate($cert.GetCertHashString(), "my")
}

function Remove-Certificate($name) {
    Get-ChildItem Cert:\LocalMachine\my | ? {$_.Subject -eq "CN=$name"} | Remove-Item
}

Export-ModuleMember -function Add-LocalDb
Export-ModuleMember -function Add-ReactApp
Export-ModuleMember -function Add-Site
Export-ModuleMember -function Add-Host
