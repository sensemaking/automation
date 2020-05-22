Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1
$hostsFile = "C:\Windows\System32\drivers\etc\hosts" 

function Add-Host($hostName, $ip = "127.0.0.1") {
    "$ip`t" + "$hostName" | Out-File $hostsFile -Append -Encoding ascii
}

function Add-Site($name, $port, $path, $hostName){
    Remove-Website $name -ErrorAction SilentlyContinue
    Remove-WebAppPool $name -ErrorAction SilentlyContinue
    Remove-Certificate $name -ErrorAction SilentlyContinue

    $appPool = New-WebAppPool $name -force
    $appPool.processModel.identityType = 0
    $appPool.managedRuntimeVersion = "v4.0"
    $appPool | Set-Item
	
    New-Website -Name $name -Port $port -PhysicalPath $path -ApplicationPool $name -HostHeader $hostName | Out-Null

    Enable-Tls $name $hostName
}

function Enable-Tls($name, $hostName) {    
    New-WebBinding -Name $name -IP "*" -Port "443" -Protocol https -HostHeader $hostName 
    $cert = New-SelfSignedCertificate -DnsName $name -CertStoreLocation "cert:\LocalMachine\My"
    (Get-WebBinding -Name $name -Protocol https).AddSslCertificate($cert.GetCertHashString(), "my")
}

function Remove-Certificate($name) {
    Get-ChildItem Cert:\LocalMachine\my | ? {$_.Subject -eq "CN=$name"} | Remove-Item
}

Export-ModuleMember -function Add-Host
Export-ModuleMember -function Add-Site
