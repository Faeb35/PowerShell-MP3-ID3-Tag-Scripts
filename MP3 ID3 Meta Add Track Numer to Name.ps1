$taglib = "C:\Folder\taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile("$taglib")

$folder = "C:\Folder"

$files = Get-ChildItem $folder -Filter *.mp3;

 
foreach ($file in $files) {
    $media = [taglib.file]::create($file.FullName)
    $trackNr = $media.tag.Track
    if ($trackNr -lt 10) {
        $newName =  $("0" + $trackNr.ToString() + " - " + $file.Name)
    } else {
        $newName = $($trackNr.ToString() + " - " + $file.Name) 
    }
    Rename-Item $file.Fullname -NewName $newName
}