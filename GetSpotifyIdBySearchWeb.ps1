#region config
$albumListFile = "albumlist.txt"
$albumUrisFile = "albumUris.txt"

$global:spotifyApiUri = "https://spclient.wg.spotify.com"
#Get here: Bearer from Browser Developer Tools 
$global:spotifyOAuthToken = "XXXXX"

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

Foreach ($albumName in $albumNames) {

    $spotifyAlbums = SearchForAlbumOnSpotify -albumName $albumName

    If ($spotifyAlbums.topHit) {
        If ($spotifyAlbums.albums.total -eq 1) {
            $spotifyAlbumUri = $spotifyAlbums.albums.hits[0].uri
        } else {
            $spotifyAlbumUri = $spotifyAlbums.topHit.hits[0].uri
        }
        Write-Host "$($spotifyAlbumUri)`t`t $($albumName): Found matching item" -ForegroundColor Green
        "$spotifyAlbumUri" | Add-Content $albumUrisFile
        
    } Else {
        Write-Host "$($albumName): Not able to find matching album" -ForegroundColor Red
    }
    
}
#endregion