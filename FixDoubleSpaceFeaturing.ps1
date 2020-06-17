##fix all albums, replace "(feat.  " mit "(feat. "
#region config
$albumDirectory = "C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$replace = "(feat.  "
$replaceWith = "(feat. "
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
$albumMp3Files = Get-ChildItem -Filter *.mp3 -Recurse
Write-Host "Got Files" -ForegroundColor Yellow
Foreach ($albumMp3File in $albumMp3Files) {

     $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
     $currentAlbumMp3FileTitle = $currentAlbumMp3File.Tag.Title
         #Write-Host "$albumMp3File $currentAlbumMp3FileTitle $($currentAlbumMp3FileTitle.Contains($replace))"
     If ($currentAlbumMp3FileTitle.Contains($replace)) {
        Write-Host "Updated $($albumMp3File) ""$currentAlbumMp3FileTitle""" -ForegroundColor Yellow
        $currentAlbumMp3File.Tag.Title = $currentAlbumMp3FileTitle.Replace($replace, $replaceWith)
        Write-Host "Updated after $($albumMp3File) ""$($currentAlbumMp3File.Tag.Title)""" -ForegroundColor Green
        $currentAlbumMp3File.Save()
     }
     <#$currentAlbumMp3File.Tag.Title = $currentAlbumMp3File.Tag.Title.toString().Replace($replace, $replaceWith)
     If ($currentAlbumMp3File.Tag.Title.ToString().Contains("(feat.")) {
       # $currentAlbumMp3File.Tag.Title = $currentAlbumMp3File.Tag.Title + ")"
     }
     #$currentAlbumMp3File.Tag.Title = $currentAlbumMp3File.Tag.Title.toString().substring(3)
     #>     
}
Pop-Location
#endregion