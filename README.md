# Picture Organizer PowerShell script
 
This PowerShell script provides an easy way to sort your pictures into date-based subfolders based on the date taken.

.
+-- organizedPictures
|   +-- 2018
|   |    +-- 00
|   |    +-- 01
|   |    +-- 02
|   |    +-- 03
|   +-- 2019

Useage:
Modify the variables picturesToOrganize and organizedPictures to point to directories on your hard drive. 

* picturesToOrganize - Source folder containing the pictures you need organized
* organizedPictures - Destination folder for pictures

Notes:
* Script copies files into a date-based structure
* Source files are not deleted
* No logic (yet) to handle duplicate file names (typically happens when running the script twice or on duplicate folders)
