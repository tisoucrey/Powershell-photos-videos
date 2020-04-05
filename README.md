# Powershell-photos-videos
Some homemade scripts to help me unload my DSLR's photos and videos and compress video to save space!

Those scripts have been tested on Windows 10 and PS 3.0

##CopyMemoryCardPhotosAndVideos.ps1

This script let you specify your memory card disk drive (or folder) and copy all the photos and videos to a destination folder.

A folder tree is created using metadatas 
Year
  |---Month
        |------Number of the day

Be sure to complete the files extensions in the two first lines ! 
$photoExtensions = @("nef", "jpeg", "jpg")
$videoExtensions = @("mp4", "mov")

##EncodeVideos.ps1

This script fetches all videos in a folder and compress them.
The compressed files is created in a folder hierarchy like the one in the CopyMemoryCardPhotosAndVideos script.

This script requires HandBrakeCli to be installed. 
Change the path of the executable in the folder before launching the script
The default encoding settings are : x265 1080p AAC mkv. Feel free to change the parameters
