#region config
$albumList = "albumlist.txt"
$albumMainFolder ="C:\Folder"
#endregion


#region main programm
$albumList = Get-Content $albumList


Push-Location
Set-Location $albumMainFolder
$albumFolders = Get-ChildItem -Directory
Foreach ($album in $albumList) {
    If (-not $album) {
        Continue
    }

    Write-Host "==> Got Album-Interprete Name $($album)" -ForegroundColor Green

    $albumParts = $album -split " - "

    If ($albumParts.Length -eq 1) {
        Write-Host "Error: in Albumlist, can't split value $($album)" -ForegroundColor Red
        Continue
    }

    $interpretName = $albumParts[0]

    $albumName = @()
    For ($i = 1; $i -lt $albumParts.Length; $i++) {
        $albumName += $albumParts[$i]
    }
    $albumName = $albumName -join " - "
    
    If (Test-Path $interpretName) {
        Write-Host "Interpret Folder already exists " -ForegroundColor Yellow
    } Else {
        Write-Host "Interpret Folder not existing, going to create $($interpretName)" -ForegroundColor Yellow
        New-Item -ItemType Directory $interpretName | Out-Null
    }

    $albumFolderPath = $($interpretName + "/" + $albumName)
    If (Test-Path $albumFolderPath) {
        Write-Host "Error: AlbumFolder already exists $albumFolderPath" -ForegroundColor Red
        Continue
    } Else {
        Write-Host "Album Folder not existing, going to create $($albumFolderPath)" -ForegroundColor Yellow
        New-Item -ItemType Directory $albumFolderPath | Out-Null
    }

    Write-Host "Going to move files..." -ForegroundColor Yellow
    Get-ChildItem -LiteralPath $album -File | Move-Item -Destination $albumFolderPath

    $albumFolderSize = (Get-ChildItem -LiteralPath $album -Recurse | Measure-Object -Property Length -sum -ErrorAction SilentlyContinue).sum
    If ($albumFolderSize -and $albumFolderSize -gt 0) {
        Write-Host "Error: There are still files in $($album)" -ForegroundColor Red
        Continue
    } Else {
        Remove-Item -LiteralPath $album -Recurse
    }

}
Pop-Location
#endregion