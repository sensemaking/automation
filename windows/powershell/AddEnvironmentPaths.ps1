$paths = 
	"$env:programFiles\Git\bin",
	"$env:programFiles\Git\usr\bin",
	"$env:programFiles(x86)\MSBuild\14.0\Bin",
	"$env:programFiles\Microsoft VS Code",
	"${env:programFiles(x86)}\Google\Chrome\Application\", 
	"$env:winDir\System32\inetsrv", 
	"$env:USERPROFILE\AppData\Local\slack\",
	"${env:programFiles(x86)}\nunit.org\nunit-console\",
	"${env:programFiles(x86)}\TeamViewer",
	"${env:programFiles(x86)}\MSBuild\14.0\Bin"

$paths | % {
	if(-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}
