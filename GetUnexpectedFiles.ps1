Cls
Get-ChildItem -Path K:\Musik\Alben -Exclude *.mp3,*.jpg,*.jpeg,*.txt,*.png,*.pdf,*.doc,*.rtf,*.gif,*.tif,*.tiff,*.bmp -Recurse -File


#Get-ChildItem -Path K:\Musik\Alben -Recurse -Force | Where-Object { $_.Attributes -like "*Hidden*" -and ( $_.Name -ne "Folder.jpg") }