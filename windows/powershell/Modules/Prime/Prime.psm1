
function Add-LocalDb($dbName) {
    if ((SqlLocalDB.exe info) -contains $dbName) {
        SqlLocalDB.exe stop $dbName 
        SqlLocalDB.exe delete $dbName 
    }
    
    SqlLocalDB.exe create $dbName
    SqlLocalDB.exe start $dbName
    SqlLocalDB.exe share $dbName $dbName
    
    SqlLocalDB.exe stop $dbName
}

Export-ModuleMember -function Add-LocalDb