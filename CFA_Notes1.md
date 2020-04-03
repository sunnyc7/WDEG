# Quick note on WDEG CFA (Controlled Folder Access)

## Scenario:
- CFA - https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-atp/controlled-folders
- You have followed the CFA guide listed here - https://demo.wd.microsoft.com/
- Create a folder called C:\demo
- Configure CFA to block c:\demo

## CFA Blocks
- Unsigned executables from writing to the folder
- Blocks Commandline DOS commands - touch/echo/type from writing to the folder
- Blocks Powershell.exe from writing 

## CFA Allows 
- Signed executables like excel.exe, winword.exe
- File creation using FSUTIL

## Other
- If a file EXISTS in in c:\demo, then you can modify/edit it.
- You'd need NTFS permissions to the folder. CFA is not a substitute for ACL (Access Control List)

## TODO
- Check behavior for different binaries signed by CodeSign/MSFT/Vendor Sign / Internal PKI

