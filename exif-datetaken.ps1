#param([string]$file)
[Reflection.Assembly]::LoadFile('C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.Drawing.dll') | Out-Null

# source dir
$picturesToOrganize = "C:\Users\reeves\Pictures\organizeMe\"
# destination dir
$organizedPictures = "C:\Users\reeves\Pictures\organized\"

# read the exif date taken data for an image object
function GetTakenData($image) {
	try {
		return $image.GetPropertyItem(36867).Value
	}	
	catch {
		return $null
	}
}

# take a file path, create new image object and call GetTakenData to get a date
function Get-DateTaken($filePathStr){
	$image = New-Object System.Drawing.Bitmap -ArgumentList $filePathStr
	try {
		$takenData = GetTakenData($image)
		if ($takenData -eq $null) {
			return $null
		}
		$takenValue = [System.Text.Encoding]::Default.GetString($takenData, 0, $takenData.Length - 1)
		$taken = [DateTime]::ParseExact($takenValue, 'yyyy:MM:dd HH:mm:ss', $null)
		return $taken
	}
	finally {
		$image.Dispose()
	}

}

$fileList = Get-ChildItem -Path $picturesToOrganize # -Filter "*.jpg"
# some debug output
#Write-Host "The list:"
#Write-Host $fileList

$fileListSize = ( $fileList | Measure-Object ).Count  
Write-Host "Number of files: " + $fileListSize
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# iterate through file list and copy files based on date.
foreach ($theFileObj in $fileList){
	$theFilePath = $theFileObj.FullName
	$theFileName = $theFileObj.Name
	Write-Host $theFilePath
	Write-Host $theFileName

	$taken = Get-DateTaken($theFilePath)
	
	Write-Host "Taken date: $taken"
	# debug - uncomment to pause on each image
	#$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	
	# test to see if there is a taken date (TODO: organize on creation date if no taken exif)
	if (-not $taken){
		Write-Host "NO TAKEN DATE"
		$theYear = "00"
		$theMonth = "0"  
	} else {
		$theYear = $taken.Year
		$theMonth = $taken.Month  
	}

	Write-Host "The year: $theYear"
	Write-Host "The month: $theMonth"

	$targetFolder = $organizedPictures + $theYear + "\"
	# Pad January - September with a leading zero for sorting
	if ($theMonth -lt 10){
		$targetFolder += "0"
	}

    # construct needed paths
	$targetFolder = $targetFolder + $theMonth + "\" 
	$targetFile = $targetFolder + $theFileName

    # See if the folder exists (could just use a force, but being conservative for now
	if(-not (Test-Path -Path $targetFolder)) {
		New-Item -ItemType directory -Path $targetFolder
	}

	Write-Host "Copying $theFilePath to $targetFile"
	try {
		copy-item $theFilePath $targetFile
	}
	catch {
		Write-Host "COPY ERROR!!!"
	}
	Write-Host "`r`n"
	
}

