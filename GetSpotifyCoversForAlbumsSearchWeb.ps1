#region config
$albumListFile = "albumlist.txt"
$albumDirectory = "C:\Folder"
$coverImageFileName = "cover.jpg" #just temporary

$global:spotifyApiUri = "https://spclient.wg.spotify.com"
#Get here: Bearer from Browser Developer Tools 
$global:spotifyOAuthToken = "XXXXX"

$taglib = "$((Get-Location).Path)/taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib") | Out-Null

Add-Type -Assembly System.Web
#endregion

#region functions
Function SearchForAlbumOnSpotify() {
    Param ( 
            [Parameter(Mandatory=$True,ValueFromPipeline=$False,ValueFromPipelinebyPropertyName=$False)]
            [String]$albumName
    )  
    Begin { 
        $albumNameEncoded = [System.Web.HttpUtility]::UrlEncode($albumName)
        $albumNameEncoded = $albumNameEncoded.toString().Replace("+", "%20")
        $uri = "$($global:spotifyApiUri)/searchview/km/v4/search/$($albumNameEncoded)?entityVersion=2&limit=10&imageSize=large&catalogue=&country=C&locale=de&platform=web"
    }  
    Process { 
        $result = Invoke-Restmethod -Method GET -Uri $($uri) -ContentType "application/json" -Headers @{"Authorization" = "Bearer $($global:spotifyOAuthToken)"}
    }
    End {
        Write-Output $result.results
    }
}
#endregion


#region main programm
$albumNames = Get-Content $albumListFile

Push-Location
Foreach ($albumName in $albumNames) {

    Set-Location $albumDirectory
    Set-Location $albumName
    $spotifyAlbums = SearchForAlbumOnSpotify -albumName $albumName

    If ($spotifyAlbums.topHit) {
        Write-Host "$($albumName): Found matching album" -ForegroundColor Green
        $spotifyAlbumImageUrl = $spotifyAlbums.topHit.hits[0].image
        
        Invoke-WebRequest $spotifyAlbumImageUrl -OutFile $coverImageFileName
        $albumCoverPicture = [taglib.picture]::CreateFromPath("$((Get-Location).Path)/$($coverImageFileName)")
        
        $albumMp3Files = Get-ChildItem -Filter *.mp3
        Foreach ($albumMp3File in $albumMp3Files) {
            $currentAlbumMp3File = [taglib.file]::create($albumMp3File.FullName)
            $currentAlbumMp3File.tag.pictures = $albumCoverPicture
            $currentAlbumMp3File.Save()
            Write-Host "Updated image $($albumMp3File)" -ForegroundColor Yellow
        }

        Remove-Item $coverImageFileName
    } Else {
        Write-Host "$($albumName): Not found matching album (found $($spotifyAlbums.total))" -ForegroundColor Red
    }
    
}
Pop-Location
#endregion