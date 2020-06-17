#region config
$albumDirectory = "C:\Folder"
$re = [regex]"^[0-9]{1,3}\s{1}[-]\s{1}.+\s{1}[-]\s{1}.+\.mp3$"
#endregion


#region main programm
Get-ChildItem -Path $albumDirectory -File -Recurse -Include *.mp3 | Where { -not $re.IsMatch($_.Name) }
#endregion


