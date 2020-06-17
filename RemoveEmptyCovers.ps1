#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
$albumMp3Files = Get-ChildItem -Filter *.mp3
Foreach ($albumMp3File in $albumMp3Files) {
    $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
    $albumCoverPicture = [taglib.picture]::CreateFromPath("$((Get-Location).Path)/cover.jpg")
    $albumCoverPicture.Description = "" 
    $currentAlbumMp3File.tag.Pictures = $albumCoverPicture
    $currentAlbumMp3File.Save()
    Write-Host "Updated $($albumMp3File)" -ForegroundColor Yellow
}
Pop-Location
#endregion