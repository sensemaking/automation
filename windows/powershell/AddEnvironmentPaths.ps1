$paths = 
	"$env:programFiles\Git\bin", 
	"${env:programFiles(x86)}\Google\Chrome\Application\", 
	"$env:winDir\System32\inetsrv", 
	"$env:USERPROFILE\AppData\Local\slack\",
	"$env:programFiles\PostgreSQL\9.6\bin",
	"$env:programFiles\PostgreSQL\9.6\pgAdmin 4\bin"

$paths | % {
	if(-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}