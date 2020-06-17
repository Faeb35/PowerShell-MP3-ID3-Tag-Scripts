#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$replace = " w; "
$replaceWith = "/"
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
$albumMp3Files = Get-ChildItem -Filter *.mp3
Foreach ($albumMp3File in $albumMp3Files) {
     $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
     #$currentAlbumMp3File.Tag.Artists = $currentAlbumMp3File.Tag.Artists -join ";"
     $currentAlbumMp3File.Tag.Artists   = ($currentAlbumMp3File.Tag.Artists -join ";").Replace($replace, $replaceWith)
     #$currentAlbumMp3File.Tag.AlbumArtists = $currentAlbumMp3File.Tag.AlbumArtists.Replace($replace, $replaceWith)
     $currentAlbumMp3File.Save()

     Write-Host "Updated $($albumMp3File)" -ForegroundColor Yellow
}
Pop-Location
#endregion