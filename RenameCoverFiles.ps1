#NOT FINISHED!

#region config
$albumDirectory = "C:\Folder"
#endregion


#region main programm
Push-Location
$artistFolders = Get-ChildItem -Path $albumDirectory -Directory



foreach ($artistFolder in $artistFolders) {
    Set-Location $artistFolder.FullName
    Get-ChildItem -Include

}
Pop-Location
#endregion