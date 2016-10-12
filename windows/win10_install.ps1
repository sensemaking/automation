install-windowsUpdate -acceptEula

choco install googlechrome -yr
 & "${env:programFiles(x86)}\Google\Chrome\Application\chrome.exe" --make-default-browser
choco install skype -yr
choco install sublimetext3 -yr
choco install visualstudio2015community -yr
choco install mssqlserver2014express -yr