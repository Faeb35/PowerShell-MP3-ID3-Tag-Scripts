#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$featuringDelimiter = " feat. "
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
$albumMp3Files = Get-ChildItem -Filter *.mp3
Foreach ($albumMp3File in $albumMp3Files) {
     $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
     $currentArtistArray = $currentAlbumMp3File.Tag.Artists -split $featuringDelimiter
     #$currentArtistArray
     
     If ($currentArtistArray.Length -gt 1 -and -not ($currentAlbumMp3File.tag.Title -match "feat. ")) {
        $currentAlbumMp3File.tag.Title = $currentAlbumMp3File.tag.Title + " (feat. " + ($currentArtistArray[1]) + ")"
        $currentAlbumMp3File.Tag.Artists = $currentArtistArray[0]
        Write-Host "Updated title of file $($albumMp3File)" -ForegroundColor Yellow
     }
     #$currentAlbumMp3File.tag.Title

     $currentAlbumMp3File.Save()
}
Pop-Location
#endregion