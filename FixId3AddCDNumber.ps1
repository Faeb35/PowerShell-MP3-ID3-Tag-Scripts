#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
#$albumCoverPicture = [taglib.picture]::CreateFromPath("$albumDirectory\cover.jpg")
$albumMp3Files = Get-ChildItem -Filter *.mp3
Foreach ($albumMp3File in $albumMp3Files) {
     $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
     Rename-Item $albumMp3File.Fullname -NewName "$($currentAlbumMp3File.Tag.Disc.toString())$albumMp3File"
     #Rename-Item $albumMp3File.Fullname -NewName $albumMp3File.ToString().substring(1) #reverse it
     Write-Host "Updated $($albumMp3File)" -ForegroundColor Yellow
}
Pop-Location
#endregion