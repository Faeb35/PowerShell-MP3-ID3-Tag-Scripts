#region config
$albumDirectory = "C:\Folder"
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
$albumFolders = Get-ChildItem -Directory | Where { $_.Name -like "*_*" }
Foreach ($albumFolder in $albumFolders) {

     Write-Host "Updated $($albumFolder)" -ForegroundColor Yellow
     Rename-Item $albumFolder.Fullname -NewName $albumFolder.ToString().Replace("_", " ")
     
}
Pop-Location
#endregion