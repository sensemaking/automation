$paths = 
"${env:programFiles(x86)}\Google\Chrome\Application\", 
"$env:programFiles\BraveSoftware\Brave-Browser\Application",
"$env:programFiles\curl\bin",
"$env:programFiles\Git\bin",
"$env:programFiles\Microsoft VS Code",
"$env:programFiles\Azure Data Studio",
"$env:programFiles\Azure Cosmos DB Emulator",
"$env:userProfile\.local\bin"

$paths | % {
	if (-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}