Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1

function Add-LocalDb($dbName){
    if((SqlLocalDB.exe info) -contains $dbName) {
        SqlLocalDB.exe stop $dbName 
        SqlLocalDB.exe delete $dbName 
    }
    
    SqlLocalDB.exe create $dbName
    SqlLocalDB.exe start $dbName
    SqlLocalDB.exe share $dbName $dbName

    SQLCMD.exe -S "(localdb)\$dbName" -E -Q "if(db_id($dbName) is null) create database $dbName"

    SqlLocalDB.exe stop $dbName
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

Export-ModuleMember -function Add-Site
Export-ModuleMember -function Add-LocalDb
