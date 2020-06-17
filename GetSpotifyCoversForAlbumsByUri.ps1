#region config
$albumUrisFile = "albumUris.txt"
$albumDirectory = "C:\Folder"
$coverImageFileName = "cover.jpg" #just temporary

$global:spotifyApiUri = "https://api.spotify.com/v1"
#Get here: https://developer.spotify.com/console/get-search-item/?q=&type=&market=&limit=&offset=
$global:spotifyOAuthToken = "XXXX"

$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null
#endregion

#region functions
Function GetAlbumFromSpotify() {
    Param ( 
            [Parameter(Mandatory=$True,ValueFromPipeline=$False,ValueFromPipelinebyPropertyName=$False)]
            [String]$albumUri
    )  
    Begin {
        $uri = "$($global:spotifyApiUri)/albums/$($albumUri)"
    }  
    Process { 
        $result = Invoke-Restmethod -Method GET -Uri $($uri) -ContentType "application/json; charset=utf-8" -Headers @{"Authorization" = "Bearer $($global:spotifyOAuthToken)" }
    }
    End {
        Write-Output $result
    }
}
#endregion


#region main programm
$albumUris = Get-Content $albumUrisFile

Push-Location
Foreach ($albumUri in $albumUris) {

    If (-not $albumUri) {
        Continue
    }

    Set-Location $albumDirectory
    $albumUri = ($albumUri -split ":")[2]

    try {
        $spotifyAlbum = GetAlbumFromSpotify -albumUri $albumUri
    } catch {
        Write-Host "Problem with getting album from Spotify $_" -ForegroundColor Red
        Continue
    }

    $albumName = "$($spotifyAlbum.artists[0].name) - $($spotifyAlbum.name)"
    $albumName = $albumName -replace "\s*/\s*"," & "
    $albumName = $albumName -replace '\s*[\\/:"*?<>|]+\s*'," "
    $albumName = $albumName.Trim()
    $albumName = $albumName -replace "(^\.+\s*|(?<=\.)\.+|\s*\.+$)",""
    $albumName = $albumName.Replace("[", "``[")
    $albumName = $albumName.Replace("]", "``]")

    Set-Location $albumName -ErrorAction SilentlyContinue
    if (-not $?) {
        Write-Host "Not able to find local album according to name $($albumName)" -ForegroundColor Red
        Continue
    }
 
    If ($spotifyAlbum) {
        Write-Host "$($albumName): Found matching album" -ForegroundColor Green

        $spotifyAlbumImages = $spotifyAlbum.images | Sort-Object -Property height -Descending
        $spotifyAlbumImageUrl = $spotifyAlbumImages[0].url
        
        Invoke-WebRequest $spotifyAlbumImageUrl -OutFile $coverImageFileName
        $albumCoverPicture = [taglib.picture]::CreateFromPath("$((Get-Location).Path)/$($coverImageFileName)")
        
        $albumMp3Files = Get-ChildItem -Filter *.mp3
        Foreach ($albumMp3File in $albumMp3Files) {
            $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
            $currentAlbumMp3File.tag.pictures = $albumCoverPicture
            $currentAlbumMp3File.Save()
            Write-Host "Updated image of file $($albumMp3File)" -ForegroundColor Yellow
        }

        Remove-Item $coverImageFileName
    } Else {
        Write-Host "$($albumName): Not found matching album" -ForegroundColor Red
    }
    
}
Pop-Location
#endregion