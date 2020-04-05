$photoExtensions = @("nef", "jpeg", "jpg")
$videoExtensions = @("mp4", "mov")

write-host "Specify the Windows path for your memory card (ex: d:\)"
$memoryCardPath = read-host
write-host "Files contained in the memory card $memoryCardPath will be copied"
$defaultPhotosStorePath = "C:\Users\mickael\Pictures\raws"
$defaultVideosStorePath = "C:\Users\mickael\Videos\"

$photosDestination = read-host "Specify the photos destination folder's path (leave empty if using the default path $defaultPhotosStorePath) "
if($photosDestination -eq $null -or $photosDestination -eq [string]::Empty) {
	$photosDestination = $defaultPhotosStorePath
}
	
$videosDestination = read-host "Specify the videos destination folder's path (leave empty if using the default path $defaultVideosStorePath) "
if($videosDestination -eq $null -or $videosDestination -eq [string]::Empty) {
	$videosDestination = $defaultVideosStorePath
}
# Get the files which should be moved, without folders
$files = Get-ChildItem $memoryCardPath -Recurse | where {!$_.PsIsContainer} | foreach ($_) { $_.fullname } | sort
 
foreach ($file in $files)
{
	#get the file's full path and filename without extension
	$fileItem = (Get-Item $file )
	$fileFolder = $fileItem.DirectoryName
	$tmpFileName = $fileItem.Name.Split('.')
	$filename = $fileItem.Name.SubString(0, $fileItem.Name.LastIndexOf('.'))
	$extension = $tmpFileName[$tmpFileName.length -1].toLower()
	$destinationRoot = [string]::Empty
	if($photoExtensions.Contains($extension)){
		$destinationRoot = $photosDestination
	} elseif ($videoExtensions.Contains($extension)){
		$destinationRoot = $videosDestination
	} else {
		write-host "Skipping file $file because its extension isn't targeted"
		Continue
	}
	$tmpDate = $fileItem.LastWriteTime.ToString()
	$year = $fileItem.LastWriteTime.Year.ToString()
	$monthNumber = $fileItem.LastWriteTime.Month.ToString().PadLeft(2, "0");
	$month = $fileItem.LastWriteTime.ToString("MMMM")
	$day = $fileItem.LastWriteTime.Day.ToString().PadLeft(2, "0");
	
	$directory = $destinationRoot + "\" + $year + "\" + $monthNumber + "-" + $month + "\" + $day
	if (!(Test-Path $directory))
	{
		New-Item $directory -type directory
	}
	
	$fileDestination = $directory + "\" + $filename + "." + $extension
	if ((Test-Path $fileDestination))
	{
		write-host "The file $filename already exists at $fileDestination"
	} else {
		write-host "Copying file $filename shot at $tmpDate to path $fileDestination"
		$file | Copy-Item -Destination $Directory
	}
}
write-host "Operation completed"
read-host