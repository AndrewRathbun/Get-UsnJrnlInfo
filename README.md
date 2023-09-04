# Get-UsnJrnlInfo ($Max)

`Get-UsnJrnlInfo.ps1` is a simple PowerShell script utilized to parse `$UsnJrnl` information from an extracted `$Max` file.  

## TL;DR

The NTFS Change Journal (aka USN Journal) is stored in the hidden system file `$Extend\$UsnJrnl`. The `$UsnJrnl` file contains two alternate data streams (ADS). The `$Max` and the `$J`. `$J` contains records of file system operations and the `$Max` data stream contains metadata about the USN Journal configuration.  

File Location:  
`[root]\$Extend\$UsnJrnl:$Max`  

![fsutil](https://raw.githubusercontent.com/AndrewRathbun/Get-UsnJrnlInfo/main/Screenshots/fsutil.png)

**Fig 1:** You can use `fsutil` to query the `$UsnJrnl` information for a specific NTFS volume on a live system.

## Usage
1. Mount your forensic image (or VHDX Container) and manually extract the `$Max` file.  

![FTK-Imager](https://raw.githubusercontent.com/AndrewRathbun/Get-UsnJrnlInfo/main/Screenshots/FTK-Imager.png)  
**Fig 2:** Extracting `$Max` file w/ FTK-Imager  
  
2. Run Windows PowerShell console as Administrator.  

![Get-UsnJrnlInfo](https://raw.githubusercontent.com/AndrewRathbun/Get-UsnJrnlInfo/main/Screenshots/Get-UsnJrnlInfo.png)

**Fig 3:** Changing File Attributes (if needed) and running `Get-UsnJrnlInfo.ps1`  

```
# Check File Attributes of the $Max File
PS > $File = Get-ChildItem "C:\Users\evild3ad\Desktop\`$Max" -Force
PS > $File.Attributes
Hidden, System
```
```
# Change File Attributes of the $Max File (Unhide the $Max File)
PS > $File.Attributes="Archive","ReadOnly"
PS > $File.Attributes
ReadOnly, Archive
```
```
# Running Get-UsnJrnlInfo.ps1 against manual extracted $Max file (e.g. FTK-Imager)
PS > .\Get-UsnJrnlInfo.ps1 -PathToMaxFile "C:\Users\evild3ad\Desktop\`$Max"
```
```
# Running Get-UsnJrnlInfo.ps1 against mounted VHDX-Container (e.g. KAPE)
PS > .\Get-UsnJrnlInfo.ps1 -PathToMaxFile "G:\C\$Extend\`$Max"
```
