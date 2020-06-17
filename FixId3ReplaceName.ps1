#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$replace = " (feat. XXXXX)"
$replaceWith = ""
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
#$albumCoverPicture = [taglib.picture]::CreateFromPath("$albumDirectory\cover.jpg")
$albumMp3Files = Get-ChildItem -Filter *.mp3
Foreach ($albumMp3File in $albumMp3Files) {
     Rename-Item $albumMp3File.Fullname -NewName $albumMp3File.ToString().Replace($replace, $replaceWith)
     Write-Host "Updated $($albumMp3File)" -ForegroundColor Yellow
}
Pop-Location
#endregion