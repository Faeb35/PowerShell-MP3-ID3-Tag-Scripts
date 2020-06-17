#region config
$albumMainFolder ="C:\Folder"
$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
$imgConverter = [System.Drawing.ImageConverter]::new()
#endregion

#region main programm
$mp3Files = Get-ChildItem -Path $albumMainFolder -File -Include *.mp3 -Recurse

foreach ($mp3File in $mp3Files) {

    Write-Host "Testing $($mp3File.FullName)" -ForegroundColor Yellow
    $mp3FileTagLib = [taglib.file]::create($mp3File.FullName)
    try {
        foreach ($picture in $mp3FileTagLib.Tag.Pictures) {
            $imgConverter.ConvertFrom($picture.Data.Data) | Out-Null
        }
    } catch {
        Write-Host "$($mp3File.FullName) ==> Image not valid" -ForegroundColor Red
    }
}
#endregion