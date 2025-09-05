@echo off
title Youtube Downloader×Converter
if not exist config.ini goto url
for /F "tokens=1,2 delims==" %%a in ('findstr "^" ".\config.ini"') do (set "%%a=%%b")
if "%login%"=="true" (
  if exist cookies.txt (
    set loginatt=--cookies cookies.txt
  ) else (
    set loginatt=--cookies cookies.txt --cookies-from-browser %browser%
  )
  set logincolor=green
) else (
  set logincolor=red
)
powershell write-host -fore %logincolor% "%login%" -NoNewLine
echo. %browser%
echo. %loginatt%



:url
set /p url=Enter url (enter "bulk" to skip to bulk convert):
if "%url%"=="bulk" goto bulk

:lang
echo. enter 2 letter language codes!
set /p lang=Enter language (skip to all, list to list, nosub to no subs):
if "%lang%"=="list" (
  yt-dlp --skip-download --list-subs "%url%"
  goto lang
)
if "%lang%"=="nosub" goto nosub
if "%lang%"=="" set lang=all

choice /c yn /m "Include auto? y/n:" /n
  if "%errorlevel%"=="1" goto yes
  if "%errorlevel%"=="2" goto no
  
:: descargar todos los autos es simplemente "all", al incluir un lenguaje se indica que se traduce de cualquiera con '*'
:: no especificar deberia descargarlos todos igualmente
:yes
if "%lang%"=="all" (
  yt-dlp %loginatt% --write-subs --write-auto-sub --sub-langs all --sub-format=srv3 "%url%"
) else (
  yt-dlp %loginatt% --write-subs --write-auto-sub --sub-langs "%lang%.*" --sub-format=srv3 "%url%"
)
goto bulk

:: subtitulos sin auto. sub-lang descarga todos al no especificar
:no
yt-dlp %loginatt% --write-subs --sub-langs "%lang%" --sub-format=srv3 "%url%"
goto bulk

:nosub
yt-dlp %loginatt% "%url%"

:bulk
for %%f in (*.srv3) do (
    if "%%~xf"==".srv3" (
	YTSubConverter --visual "%%f"
    )
)
for %%f in (*.ytt) do (
    if "%%~xf"==".ytt" (
	YTSubConverter --visual "%%f"
    )
)
powershell write-host -fore green //////////
powershell write-host -fore green // Done //
powershell write-host -fore green //////////
pause
