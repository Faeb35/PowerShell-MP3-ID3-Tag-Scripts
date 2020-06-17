#region config
$albumMainFolder ="C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$imgConverter = [System.Drawing.ImageConverter]::new()
#endregion

#region functions
function IsJpegImage {
    param(
        [string]
        $FileName
    )

    try {
        $img = [System.Drawing.Image]::FromFile($filename)
        return $img.RawFormat.Equals([System.Drawing.Imaging.ImageFormat]::Jpeg)
    }
    catch [OutOfMemoryException] {
        return $false;
    }
}
#endregion

#region main programm
Push-Location
Set-Location $albumMainFolder
$artistFolders = Get-ChildItem -Directory | Where { $_.Name -eq "Deyro" -or  $_.Name -eq "The Product" -or $_.Name -eq "DJ Craze" -or $_.Name -eq "Royce Da 5'9" -or $_.Name -eq "Max RubaDub" } #Max -> Don't Fight 

Foreach ($artistFolder in $artistFolders) {

    $albumFolders =  Get-ChildItem -Directory -Path $artistFolder.FullName
    
    Foreach ($albumFolder in $albumFolders) {
        Write-Host $albumFolder.FullName -ForegroundColor Green

        $currentAlbumImageFiles = Get-ChildItem -File -Path $albumFolder.FullName -Include *.jpg,*.png,*.gif | Measure-Object

        $currentAlbumImageFiles.Count

        $currentAlbumMp3Files = Get-ChildItem -File -Path $albumFolder.FullName -Filter *.mp3

        Foreach ($currentAlbumMp3File in $currentAlbumMp3Files) {
            Write-host $currentAlbumMp3File.Name -ForegroundColor Yellow
            $currentAlbumMp3FileTaglib = [taglib.file]::create($currentAlbumMp3File.FullName)
            try {
                $imgConverter.ConvertFrom($currentAlbumMp3FileTaglib.Tag.Pictures[0].Data.Data) | Out-Null
            } catch {
                Write-Host "$($currentAlbumMp3File.Name) ==> Image not valid" -ForegroundColor Red
            }

        }
    }


     #$currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
     #$currentAlbumMp3File.Tag.Artists = $currentAlbumMp3File.Tag.Artists.Replace($replace, $replaceWith)
     #$currentAlbumMp3File.Tag.AlbumArtists = $currentAlbumMp3File.Tag.AlbumArtists.Replace($replace, $replaceWith)
     #$currentAlbumMp3File.Save()

     #Write-Host "Updated $($albumMp3File)" -ForegroundColor Yellow
}
Pop-Location
#endregion