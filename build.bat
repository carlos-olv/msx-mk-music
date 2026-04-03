@echo off
cls

tniasm.exe %1 %2


rem Do Error Beep (BEL)
set ERR=%ERRORLEVEL%
if %ERR% neq 0 (
    @echo 
    @echo 
)

del tniasm.tmp


if %ERR% neq 0 (Exit /b %ERR%)

rem Padding for 4Mb
rem ---------------

set TARGET=4194304
set FILE=%2

for %%F in (%FILE%) do set SIZE=%%~zF

if %SIZE% GEQ %TARGET% (
  echo Already %SIZE% bytes, do nothing
  goto :EOF
)

set /a PAD=%TARGET%-%SIZE%
rem echo Padding %FILE% de %SIZE% para %TARGET% bytes...

fsutil file createnew pad.tmp %PAD% >nul
@echo off
copy /b %FILE% + pad.tmp %FILE%.tmp >nul 
move /y %FILE%.tmp %FILE% >nul

del pad.tmp


