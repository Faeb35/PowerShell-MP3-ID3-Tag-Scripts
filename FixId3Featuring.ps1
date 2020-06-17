#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$asFeaturing = "XXX"
$primaryPerfromer = "XXXX"
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
#$albumCoverPicture = [taglib.picture]::CreateFromPath("$albumDirectory\cover.jpg")
$albumMp3Files = Get-ChildItem -Filter *.mp3
Foreach ($albumMp3File in $albumMp3Files) {
     $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
     $currentAlbumMp3File.Tag.Performers = "$primaryPerfromer/$asFeaturing"
     $currentAlbumMp3File.Tag.Title = $currentAlbumMp3File.Tag.Title.toString().Replace(" (feat. $asFeaturing)", "")
     $currentAlbumMp3File.Tag.Title = $currentAlbumMp3File.Tag.Title.toString().Replace(" (feat. $asFeaturing,", " (feat.")
     #$currentAlbumMp3File.tag.pictures = $albumCoverPicture
     
     $currentAlbumMp3File.Save()

     Rename-Item $albumMp3File.Fullname -NewName $albumMp3File.toString().Replace("$primaryPerfromer", "$primaryPerfromer & $asFeaturing")
     Write-Host "Updated $($albumMp3File)" -ForegroundColor Yellow
}
Pop-Location
Rename-Item $albumDirectory -NewName $albumDirectory.toString().Replace("$primaryPerfromer", "$primaryPerfromer & $asFeaturing")
#endregion