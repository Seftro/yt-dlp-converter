@echo off
title Youtube Downloader Converter

set /p url=Enter url (enter "bulk" to skip to bulk convert):
if "%url%"=="bulk" goto bulk

:lang
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

:yes
if "%lang%"=="all" (
  yt-dlp --write-subs --write-auto-sub --sub-langs all --sub-format=srv3 "%url%"
) else (
  yt-dlp --write-subs --write-auto-sub --sub-langs "%lang%.*" --sub-format=srv3 "%url%"
)
goto bulk

:no
yt-dlp --write-subs --sub-langs "%lang%" --sub-format=srv3 "%url%"
goto bulk

:nosub
yt-dlp "%url%"

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
echo.Finish
pause