$paths = 
"${env:programFiles(x86)}\Google\Chrome\Application\", 
"$env:programFiles\BraveSoftware\Brave-Browser\Application",
"${env:programFiles(x86)}\TeamViewer",
"$env:programFiles\curl\bin",
"$env:programFiles\Git\bin",
"$env:programFiles\Microsoft VS Code",
"${env:programFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\IDE",
"$env:programFiles\Azure Data Studio",
"$env:programFiles\Azure Cosmos DB Emulator"

$paths | % {
	if (-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}