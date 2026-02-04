@echo off
setlocal enabledelayedexpansion

title PNG zu ICO Konverter
color 0A

set INPUT=eingabe
set OUTPUT=ausgabe

echo ============================================
echo   PNG  ->  ICO KONVERTER
echo   (OHNE PYTHON, NUR WINDOWS)
echo ============================================
echo.
echo Hinweis:
echo Ein gutes EXE-Icon sollte mindestens 256x256 Pixel haben.
echo Kleinere Bilder funktionieren, sehen aber unscharf aus.
echo.
echo Lege PNG-Dateien in den Ordner: %INPUT%
echo.

REM Ordner erstellen
if not exist "%INPUT%" mkdir "%INPUT%"
if not exist "%OUTPUT%" mkdir "%OUTPUT%"

set FOUND=0

for %%i in ("%INPUT%\*.png") do (
    set FOUND=1
    set INPUTFILE=%%i
    set NAME=%%~ni
    set OUTPUTFILE=%OUTPUT%\!NAME!.ico

    echo Konvertiere: !INPUTFILE!  ->  !OUTPUTFILE!

    powershell -command ^
      "Add-Type -AssemblyName System.Drawing;" ^
      "$img = [System.Drawing.Image]::FromFile('!INPUTFILE!');" ^
      "$bmp = New-Object System.Drawing.Bitmap $img;" ^
      "$icon = [System.Drawing.Icon]::FromHandle($bmp.GetHicon());" ^
      "$fs = New-Object System.IO.FileStream('!OUTPUTFILE!', 'Create');" ^
      "$icon.Save($fs);" ^
      "$fs.Close();"
)

if !FOUND! EQU 0 (
    echo Keine PNG-Dateien im Ordner "%INPUT%" gefunden.
    pause
    exit /b
)

echo.
echo ============================================
echo   FERTIG! Alle ICOs liegen in: %OUTPUT%
echo ============================================
echo.
pause
exit /b
