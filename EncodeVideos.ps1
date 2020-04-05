#Path to the handbrakecli program
$handbrakeCLI = "C:\Program Files\HandBrake\HandBrakeCLI.exe" # Downloaded at https://handbrake.fr/downloads2.php
#Path to the folder containing the videos to encode
$sourceFolder = "C:\Users\mickael\Videos"
#Path to the destination folder
$destinationFolder = "D:\Vidéos"

#Encoding parameters : 1080p x265 AAC mkv 
$encode = "x265"
$aencode = "av_aac"
$format = "av_mkv" #av_mp4 or av_mkv
$width = 1920
$height = 1080
$outputExtension = ".mkv"

#Get all the videos files with extensions .mp4 and .mov from the source folder
$filelist = get-childitem $sourceFolder -include *.mp4,*.mov -recurse | foreach ($_) { $_.fullname } | sort
#foreach file to encode
foreach($file in $filelist){
	#get the file's full path and filename without extension
	$fileFolder = (Get-Item $file ).DirectoryName
	$filename = (Get-Item $file ).Name.Split('.')[0]
	#Set the destination folder, keeping the same folder hierarchy
	$fileDestinationFolder = $fileFolder.Replace($sourceFolder, $destinationFolder)
	Write-Host "Creating folder $fileDestinationFolder if necessary"
	if((Get-Item -Path "$fileDestinationFolder" -ErrorAction SilentlyContinue) -eq $null){
		New-Item -path "$fileDestinationFolder" -type directory -ErrorAction SilentlyContinue 
	}

	if((Get-Item "$fileDestinationFolder\$filename.mkv" -ErrorAction SilentlyContinue) -eq $null){
		Write-Host "$fileDestinationFolder\$filename$outputExtension does not exists. It will be encoded"
		& $handbrakeCLI -i "$file" -o "$fileDestinationFolder\$filename$outputExtension" -e $encode -f $format --encoder-preset slow -q 22.0 -2 -E $aencode -w $width -l $height
	} else {
		Write-Host "$fileDestinationFolder\$filename$outputExtension already exists. File skipped"
	}
}