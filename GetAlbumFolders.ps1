$albumPath = "C:\Folder"
$outfile = "albumlist.txt"
Remove-Item $outfile -ErrorAction SilentlyContinue

#$albumFolders = Get-ChildItem $albumPath | Where-Object {$_.LastWriteTime -ge [datetime]"2019/12/15" -and $_.LastWriteTime -le [datetime]"2020/02/22" -and $_.name -like "* - *" } #| Select-Object -First 50

#$albumFolders = Get-ChildItem $albumPath | Where-Object {$_.LastWriteTime -ge [datetime]"2020/01/20" -and $_.LastWriteTime -le [datetime]"2020/02/02" -and $_.name -like "XXX -*" } #| Select-Object -First 50
#$albumFolders = Get-ChildItem $albumPath | Where-Object {$_.CreationTime -ge [datetime]"2019/10/20" -and $_.CreationTime -le [datetime]"2019/10/22"} #| Select-Object -First 50
#$albumFolders = Get-ChildItem $albumPath | Where-Object {$_.LastWriteTime -ge [datetime]"2020/01/06" -and $_.LastWriteTime -le [datetime]"2020/01/07"} #| Select-Object -First 50
#$albumFolders = Get-ChildItem $albumPath -Filter "DDD*"
$albumFolders = Get-ChildItem $albumPath | Where-Object { $_.name -like "* - *" } #| Select-Object -First 50

foreach ($albumFolder in $albumFolders) {
    


    $albumFolderSize = ((Get-ChildItem -LiteralPath $albumfolder.FullName -Recurse | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1MB)
    If ($albumFolderSize -and $albumFolderSize -gt 1.0) {
        
        Write-Host  $albumFolder.Name -ForegroundColor Green
        $albumFolder.Name | Out-File $outfile -Append

    } Else {
        Write-Host "Skipped: $($albumFolder.Name)" -ForegroundColor Red
    }
}
