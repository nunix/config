@echo off
setlocal
set zed=C:\msys64\mingw64.exe
start "" "%zed%" "zeditor.exe" %*
endlocal
