@echo off
chcp 65001 >nul
title YT-DLP Vietnamese Tool
setlocal enabledelayedexpansion

where yt-dlp >nul 2>nul
set HAS_YTDLP=%errorlevel%
where ffmpeg >nul 2>nul
set HAS_FFMPEG=%errorlevel%

if not exist downloads mkdir downloads

:menu
cls
echo ==========================================
echo        YT-DLP TOOL - VIETNAMESE WRAPPER
echo ==========================================
if %HAS_FFMPEG% neq 0 (
    echo [!] Trang thai: Thieu FFmpeg (Khong the gop Video+Audio HD)
) else (
    echo [v] Trang thai: He thong san sang (Full HD Support)
)
echo ------------------------------------------
echo 1. Tai video chat luong cao nhat
echo 2. Tai video theo dinh dang tuy chon (Nhap so)
echo 3. Tai chi audio
echo 4. Tai mot doan video
echo 5. Tai playlist
echo 6. Tai audio tu playlist
echo 7. Mo thu muc chua video tai ve
echo 8. Cap nhat yt-dlp
echo.
echo 0. Thoat
echo.
set choice=
set /p choice=Nhap lua chon: 

if "%choice%"=="1" goto best
if "%choice%"=="2" goto custom_format
if "%choice%"=="3" goto audio
if "%choice%"=="4" goto clip
if "%choice%"=="5" goto playlist
if "%choice%"=="6" goto playlist_audio
if "%choice%"=="7" goto opendir
if "%choice%"=="8" goto update
if "%choice%"=="0" exit
goto menu

:best
cls
if %HAS_FFMPEG% neq 0 (
    echo [CANH BAO] May ban thieu FFmpeg.
    echo Video tai ve se bi tach roi Hinh va Tieng.
    echo Ban co muon tiep tuc khong? (Y/N)
    set /p confirm=
    if /i "!confirm!" neq "Y" goto menu
)
echo === Tai video chat luong cao nhat ===
set /p url=Nhap URL video: 
if "!url!"=="" goto menu
yt-dlp -f bestvideo+bestaudio -o "downloads/%%(title)s.%%(ext)s" --merge-output-format mp4 "!url!"
pause
goto menu

:custom_format
cls
echo === Tai video theo dinh dang tuy chon ===
set /p url=Nhap URL video: 
if "!url!"=="" goto menu
echo Dang lay danh sach dinh dang...
yt-dlp -F "!url!"
if !errorlevel! neq 0 (
    echo [LOI] Link khong hop le!
    pause
    goto menu
)
echo.
set /p format_code=Nhap ma ID (VD: 299+140): 
if "!format_code!"=="" goto menu
yt-dlp -f "!format_code!" --merge-output-format mp4 -o "downloads/%%(title)s.%%(ext)s" "!url!"
pause
goto menu

:audio
cls
echo === Tai chi audio ===
set /p url=Nhap URL video: 
if "!url!"=="" goto menu
yt-dlp -f bestaudio -x --audio-format mp3 -o "downloads/%%(title)s.%%(ext)s" "!url!"
pause
goto menu

:clip
cls
echo === Tai mot doan video ===
set /p url=Nhap URL video: 
if "!url!"=="" goto menu
set /p start=Giay bat dau: 
set /p end=Giay ket thuc: 
yt-dlp --download-sections "*!start!-!end!" -f bestvideo+bestaudio --merge-output-format mp4 -o "downloads/clip_%%(title)s.%%(ext)s" "!url!"
pause
goto menu

:playlist
cls
echo === Tai playlist ===
set /p url=Nhap URL playlist: 
if "!url!"=="" goto menu
yt-dlp -o "downloads/%%(playlist_title)s/%%(playlist_index)s - %%(title)s.%%(ext)s" -f bestvideo+bestaudio --merge-output-format mp4 "!url!"
pause
goto menu

:playlist_audio
cls
echo === Tai audio tu playlist ===
set /p url=Nhap URL playlist: 
if "!url!"=="" goto menu

yt-dlp ^
  -f bestaudio ^
  -x ^
  --audio-format mp3 ^
  -o "downloads/%%(playlist_title)s/%%(playlist_index)s - %%(title)s.%%(ext)s" ^
  "!url!"

pause
goto menu

:opendir
start "" "downloads"
goto menu

:update
cls
yt-dlp -U
pause
goto menu