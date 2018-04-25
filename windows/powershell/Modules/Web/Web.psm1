Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1

$hostsFile = "C:\Windows\System32\drivers\etc\hosts" 
function Add-Hosts($hostNames) {
    $hostNames | % { 
		"127.0.0.1`t" + "$_`n" | Add-Content -PassThru $hostsFile -Force | Out-Null 
	}
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
    New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation "cert:\LocalMachine\My"
    New-WebBinding -Name $name -IP "*" -Port 443 -Protocol https -HostHeader $hostName 

    $sslPath = "IIS:\SslBindings\!443!$hostName"
    $cert = Get-Certificate($hostName)
    New-Item -Path $sslPath -Value $cert 
}


function Get-Certificate($name) {
    return Get-ChildItem Cert:\LocalMachine\my | ? {$_.Subject -eq "CN=$name"} | Select -First 1
}

function Remove-Host($hostName) {
   Get-Content $hostsFile | Select-String -Pattern $hostName -NotMatch | Out-File $hostsFile -Force
}

Export-ModuleMember -function Add-Hosts
Export-ModuleMember -function Add-Site
Export-ModuleMember -function Enable-Tls