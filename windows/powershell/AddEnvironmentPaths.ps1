$paths = 
	"${env:programFiles(x86)}\Google\Chrome\Application\", 
	"$env:USERPROFILE\AppData\Local\BraveSoftware\Brave-Browser\Application",
	"$env:programFiles\slack\",
	"${env:programFiles(x86)}\TeamViewer",
	"$env:programFiles\curl\bin",
	"$env:programFiles\Git\bin",
	"$env:programFiles\Microsoft VS Code",
	"${env:programFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\IDE",
	"$env:USERPROFILE\AppData\Local\Postman",
	"$env:winDir\System32\inetsrv", 
	"${env:programFiles(x86)}\nunit.org\nunit-console\"

$paths | % {
	if(-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}