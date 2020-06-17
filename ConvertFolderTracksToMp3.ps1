#region config
$albumDirectory = "C:\Folder"
#endregion


#region main programm
Push-Location
Set-Location $albumDirectory
$albumMp3Files = Get-ChildItem -Filter *.mpc
Foreach ($albumMp3File in $albumMp3Files) {
     Write-Host "Convert $($albumMp3File)" -ForegroundColor Yellow
     ffmpeg.exe -i "$($albumMp3File.Name)" -b:a 320K -vn "$($albumMp3File.BaseName).mp3"
}
Pop-Location
#endregion