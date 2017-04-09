Get-ChildItem D:\PROD\temp -filter "*.*" | Rename-Item -NewName { $_.Name +".xml"}
