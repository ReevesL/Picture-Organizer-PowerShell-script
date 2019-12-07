#param([string]$file)
[Reflection.Assembly]::LoadFile('C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.Drawing.dll') | Out-Null

#$picturesToOrganize = "P:\Paula's Cell Phone Pictures\"
$picturesToOrganize = "C:\Users\Reeves\OneDrive\SkyDrive camera roll\"
# $picturesToOrganize = "C:\Users\reeves\Pictures\organizeMe\"

#$organizedPictures = "P:\Paula's Cell Phone Pictures Organized\"
$organizedPictures = "C:\Users\reeves\Pictures\organized_2\"

function GetTakenData($image) {
	try {
		return $image.GetPropertyItem(36867).Value
	}	
	catch {
		return $null
	}
}

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

#$file = "C:\Users\reeves.LITTLE\Pictures\Victoria with Dick and Trina 2015\DSC_5442.JPG"



#$fileList = Get-ChildItem -Path "C:\Users\reeves.LITTLE\Pictures\Victoria with Dick and Trina 2015\*.jpg"
#$fileList = Get-ChildItem -Path "C:\Users\reeves.LITTLE\Pictures\organizeMe\" -Filter "*.jpg"
$fileList = Get-ChildItem -Path $picturesToOrganize # -Filter "*.jpg"
#Write-Host "The list:"
#Write-Host $fileList

$fileListSize = ( $fileList | Measure-Object ).Count  
Write-Host "Number of files: " + $fileListSize
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')


foreach ($theFileObj in $fileList){
	$theFilePath = $theFileObj.FullName
	$theFileName = $theFileObj.Name
	Write-Host $theFilePath
	Write-Host $theFileName

	$taken = Get-DateTaken($theFilePath)
	
	Write-Host "Taken date: $taken"
	#$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
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
	if ($theMonth -lt 10){
		$targetFolder += "0"
	}

	$targetFolder = $targetFolder + $theMonth + "\" 
	$targetFile = $targetFolder + $theFileName

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

