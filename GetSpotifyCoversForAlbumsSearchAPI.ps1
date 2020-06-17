#region config
$albumListFile = "albumlist.txt"
$albumDirectory = "C:\Folder"
$coverImageFileName = "cover.jpg" #just temporary

$global:spotifyApiUri = "https://api.spotify.com/v1"
#Get here: https://developer.spotify.com/console/get-search-item/?q=&type=&market=&limit=&offset=
$global:spotifyOAuthToken = "XXXXXX"

$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null

Add-Type -Assembly System.Web
#endregion

#region functions
Function SearchForAlbumOnSpotify() {
    Param ( 
            [Parameter(Mandatory=$True,ValueFromPipeline=$False,ValueFromPipelinebyPropertyName=$False)]
            [String]$albumName,
            [Parameter(Mandatory=$True,ValueFromPipeline=$False,ValueFromPipelinebyPropertyName=$False)]
            [String]$artistName
    )  
    Begin { 
        $uri = "$($global:spotifyApiUri)/search"
        $albumNameEncoded = [System.Web.HttpUtility]::UrlEncode($albumName)
        $artistNameEncoded = [System.Web.HttpUtility]::UrlEncode($artistName)
        $searchString = "?q=artist:""$($artistNameEncoded)""%20album:""$($albumNameEncoded)""&type=album"
    }  
    Process { 
        $result = Invoke-Restmethod -Method GET -Uri $($uri + $searchString) -ContentType "application/json; charset=utf-8" -Headers @{"Authorization" = "Bearer $($global:spotifyOAuthToken)" }
    }
    End {
        Write-Output $result.albums
    }
}
#endregion


#region main programm
$albumNames = Get-Content $albumListFile

Push-Location
Foreach ($albumName in $albumNames) {

    $album = ($albumName -split(" - "))[1]
    $artist = ($albumName -split(" - "))[0]
    $album
    $artist
    continue

    Set-Location $albumDirectory
    Set-Location $albumName
    $spotifyAlbums = SearchForAlbumOnSpotify -albumName $album -artistName $artist
 
    If ($spotifyAlbums.total -eq 1) {
        Continue
        Write-Host "$($albumName): Found matching album (found $($spotifyAlbums.total))" -ForegroundColor Green
        $spotifyAlbumImages = $spotifyAlbums.items[0].images | Sort-Object -Property height -Descending
        $spotifyAlbumImageUrl = $spotifyAlbumImages[0].url
        
        Invoke-WebRequest $spotifyAlbumImageUrl -OutFile $coverImageFileName
        $albumCoverPicture = [taglib.picture]::CreateFromPath("$((Get-Location).Path)/$($coverImageFileName)")
        
        $albumMp3Files = Get-ChildItem -Filter *.mp3
        Foreach ($albumMp3File in $albumMp3Files) {
            $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
            $currentAlbumMp3File.tag.pictures = $albumCoverPicture
            #$currentAlbumMp3File.Save()
            Write-Host "Updated image $($albumMp3File)" -ForegroundColor Yellow
        }

        Remove-Item $coverImageFileName
    } Else {
        Write-Host "$($albumName): Not found matching album (found $($spotifyAlbums.total))" -ForegroundColor Red
    }
    
}
Pop-Location
#endregion