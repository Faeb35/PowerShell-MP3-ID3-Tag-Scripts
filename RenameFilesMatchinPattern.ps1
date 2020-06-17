#region config
$albumDirectory = "C:\Folder"
$re = [regex]".*\.MP3$"
#endregion


#region main programm
Get-ChildItem -Path $albumDirectory -File -Recurse -Include *.mp3 | Where { $re.IsMatch($_.Name) } | ForEach { Rename-Item $_.FullName -NewName $($_.Name -Replace ".MP3", ".mp3") }
#endregion

