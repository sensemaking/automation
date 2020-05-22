Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1
$hostsFile = "C:\Windows\System32\drivers\etc\hosts" 

function Add-Host($hostName, $ip = "127.0.0.1") {
    "$ip`t" + "$hostName" | Out-File $hostsFile -Append -Encoding ascii
}

function Add-Site($name, $port, $path, $hostName){
    if(Test-Path IIS:\AppPools\$name) {
        Remove-Website $name
        Remove-WebAppPool $name
    }

    $appPool = New-WebAppPool $name -force
    $appPool.processModel.identityType = 0
    $appPool.managedRuntimeVersion = "v4.0"
    $appPool | Set-Item
	
    New-Website -Name $name -Port $port -PhysicalPath $path -ApplicationPool $name -HostHeader $hostName | Out-Null
}

function Enable-Tls($name, $hostName) {
    $port = 443
    $binding = New-WebBinding -Name $name -IP "*" -Port $port -Protocol https -HostHeader $hostName 

    if((Get-Certificate($hostName)) -eq $null){
        $cert = New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation "cert:\LocalMachine\My"
        $binding.AddSslCertificate($cert.GetCertHashString(), "my")
        #$sslPath = "IIS:\SslBindings\!443!$hostName"
        #$cert = Get-Certificate($hostName)
        #if(!(Test-Path -Path $sslPath)) {
        #    New-Item -Path $sslPath -Value $cert
        #}
    } 
}

function Get-Certificate($name) {
    return Get-ChildItem Cert:\LocalMachine\my | ? {$_.Subject -eq "CN=$name"} | Select -First 1
}

Export-ModuleMember -function Add-Host
Export-ModuleMember -function Add-Site
Export-ModuleMember -function Enable-Tls