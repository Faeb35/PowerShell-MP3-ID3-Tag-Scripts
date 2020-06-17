##fix alle Alben, replace "(feat.  " mit "(feat. "
#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$replace = "- Feat "
$replaceWith = "(feat. "
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
$albumMp3Files = Get-ChildItem -Filter *.mp3
Foreach ($albumMp3File in $albumMp3Files) {
     $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
     $currentAlbumMp3File.Tag.Title = $currentAlbumMp3File.Tag.Title.toString().Replace($replace, $replaceWith)
     If ($currentAlbumMp3File.Tag.Title.ToString().Contains("(feat.")) {
        #$currentAlbumMp3File.Tag.Title = $currentAlbumMp3File.Tag.Title + ")"
     }
     #$currentAlbumMp3File.Tag.Title = $currentAlbumMp3File.Tag.Title.toString().substring(3)
     $currentAlbumMp3File.Save()

     Write-Host "Updated $($albumMp3File)" -ForegroundColor Yellow
}
Pop-Location
#endregion