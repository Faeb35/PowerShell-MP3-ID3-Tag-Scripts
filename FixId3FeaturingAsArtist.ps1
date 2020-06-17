##BEFORE Running: When MainArtist as Featuring in Title and Featuring as MainArtist in Artists
# ==> Swap manually first ONLY in Title

#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$albumArtist = "CCCCCC"
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
$albumMp3Files = Get-ChildItem -Filter *.mp3
Foreach ($albumMp3File in $albumMp3Files) {
     $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)

     $currentArtist = $currentAlbumMp3File.Tag.Artists
     If ($currentArtist -ne $albumArtist) {
        
        If (-not ($currentAlbumMp3File.Tag.Title.toString().Contains("(feat."))) {
            $currentAlbumMp3File.Tag.Title = $($currentAlbumMp3File.Tag.Title.toString()) + " (feat. " + $($currentArtist) + ")"
        }
        $currentAlbumMp3File.Tag.Artists = $albumArtist
        $currentAlbumMp3File.Save()

        Rename-Item $albumMp3File.Fullname -NewName $albumMp3File.ToString().Replace($currentArtist, $albumArtist)
        
        Write-Host "Updated $($albumMp3File)" -ForegroundColor Yellow
     }
     
}
Pop-Location
#endregion