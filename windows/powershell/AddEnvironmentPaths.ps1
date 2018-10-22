$paths = 
	"$env:programFiles\Git\bin", 
	"${env:programFiles(x86)}\Google\Chrome\Application\", 
	"$env:winDir\System32\inetsrv", 
	"$env:USERPROFILE\AppData\Local\slack\",
	"${env:programFiles(x86)}\TeamViewer",
	"${env:programFiles(x86)}\nunit.org\nunit-console\",
	"${env:programFiles(x86)}\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin",
	"$env:USERPROFILE\AppData\Local\Postman\app-5.5.3",
	"$env:programFiles\Microsoft SDKs\Azure\.NET SDK\v2.9\bin\"

$paths | % {
	if(-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}
