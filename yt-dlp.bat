@echo off
setlocal EnableDelayedExpansion
title Cong cu yt-dlp (Ban Hoan Thien - Toi Uu Bang Thong)

set "DOWNLOAD_DIR=%USERPROFILE%\Downloads\YTDLP"
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"
set "COOKIES_FILE=cookies.txt"

where yt-dlp >nul 2>nul
if %errorlevel% neq 0 (
    if not exist "yt-dlp.exe" (
        echo [LOI] Khong tim thay yt-dlp.exe. Vui long tai va de chung thu muc!
        pause
        exit /b
    )
)

set "HAS_FFMPEG=1"
set "FFMPEG_STATUS=Da cai dat (Toi uu)"
where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
    set "HAS_FFMPEG=0"
    set "FFMPEG_STATUS=Thieu FFmpeg (Khong the chuyen doi am thanh/cat video)"
)

set "COOKIE_STATUS=Khong tim thay (Tai thuong)"
set "BASE_CMD=yt-dlp -P "%DOWNLOAD_DIR%""
if exist "%COOKIES_FILE%" (
    set "COOKIE_STATUS=Da tich hop (Vuot gioi han)"
    set "BASE_CMD=!BASE_CMD! --cookies "%COOKIES_FILE%""
)

:MainMenu
cls
echo [Trang thai he thong]
echo - Thu muc luu : %DOWNLOAD_DIR%
echo - Cookies     : %COOKIE_STATUS%
echo - FFmpeg      : %FFMPEG_STATUS%
echo ---------------------------------------------------
echo [Chuc nang chinh]
echo 1. Tai Video (Chon do phan giai)
echo 2. Tai Audio (MP3/FLAC - Chi tai am thanh, sieu nhanh)
echo 3. Tai Playlist/Kenh (Video MP4)
echo.
echo [Chuc nang chuyen sau]
echo 4. Tai CHI AM THANH cua Playlist (MP3 320kbps)
echo 5. Tai Video kem Phu de (Viet/Anh)
echo 6. Tai Video va xoa quang cao (SponsorBlock)
echo 7. Tai Video theo khoang thoi gian (Can FFmpeg)
echo.
echo [He thong]
echo 8. Mo thu muc luu file
echo 9. Cap nhat yt-dlp len ban moi nhat
echo 0. Thoat
echo ===================================================
set /p "CHOICE=Nhap lua chon cua ban (0-9): "

if "%CHOICE%"=="1" goto DownloadVideo
if "%CHOICE%"=="2" goto DownloadAudio
if "%CHOICE%"=="3" goto DownloadPlaylist
if "%CHOICE%"=="4" goto DownloadPlaylistAudio
if "%CHOICE%"=="5" goto DownloadSubtitle
if "%CHOICE%"=="6" goto DownloadSponsorBlock
if "%CHOICE%"=="7" goto DownloadTimeRange
if "%CHOICE%"=="8" goto OpenFolder
if "%CHOICE%"=="9" goto UpdateTool
if "%CHOICE%"=="0" exit /b
goto MainMenu

:DownloadVideo
echo.
set /p "URL=Dan link video vao day: "
if "%URL%"=="" goto MainMenu
echo.
echo 1. Tu dong (Tot nhat) ^| 2. 1080p ^| 3. 720p
set /p "RES=Chon chat luong (1-3) [Mac dinh: 1]: "
set "FORMAT=-f "bv*+ba/b""
if "%RES%"=="2" set "FORMAT=-f "bv*[height<=1080]+ba/b""
if "%RES%"=="3" set "FORMAT=-f "bv*[height<=720]+ba/b""
echo.
echo Dang tai xuong...
!BASE_CMD! %FORMAT% --merge-output-format mp4 -o "%%(title)s_%%(resolution)s.%%(ext)s" "%URL%"
echo.
pause
goto MainMenu

:DownloadAudio
echo.
set /p "URL=Dan link video/audio vao day: "
if "%URL%"=="" goto MainMenu
echo.
echo 1. MP3 (320kbps) ^| 2. FLAC (Lossless)
set /p "AUD=Chon dinh dang (1-2) [Mac dinh: 1]: "
set "A_FMT=mp3"
set "A_Q=320K"
if "%AUD%"=="2" (
    set "A_FMT=flac"
    set "A_Q=0"
)
echo.
echo Dang moc noi va tai luong am thanh...
!BASE_CMD! -f "ba/b[height<=360]/w" -x --audio-format !A_FMT! --audio-quality !A_Q! --embed-thumbnail --add-metadata -o "%%(title)s.%%(ext)s" "%URL%"
echo.
pause
goto MainMenu

:DownloadPlaylist
echo.
set /p "URL=Dan link playlist/kenh vao day: "
if "%URL%"=="" goto MainMenu
echo.
echo Dang quet va tai playlist video...
!BASE_CMD! -i -f "bv*[height<=1080]+ba/b" --merge-output-format mp4 --yes-playlist -o "%%(playlist_title)s/%%(playlist_index)02d - %%(title)s.%%(ext)s" "%URL%"
echo.
pause
goto MainMenu

:DownloadPlaylistAudio
echo.
if "!HAS_FFMPEG!"=="0" (
    echo [!] Chuc nang nay bat buoc phai co FFmpeg de chuyen doi am thanh.
    pause
    goto MainMenu
)
set /p "URL=Dan link playlist vao day: "
if "%URL%"=="" goto MainMenu
echo.
echo Dang tai chi luong am thanh tu playlist (MP3 320kbps)...
!BASE_CMD! -f "ba/b[height<=360]/w" -i -x --audio-format mp3 --audio-quality 320K --yes-playlist --embed-thumbnail --add-metadata -o "%%(playlist_title)s/%%(playlist_index)02d - %%(title)s.%%(ext)s" "%URL%"
echo.
echo [Thanh cong] Toan bo nhac da luu vao thu muc ten Playlist.
pause
goto MainMenu

:DownloadTimeRange
echo.
if "!HAS_FFMPEG!"=="0" (
    echo [!] Thieu FFmpeg, khong the cat video tren server.
    pause
    goto MainMenu
)
set /p "URL=Dan link video vao day: "
if "%URL%"=="" goto MainMenu
set /p "START_TIME=Thoi gian bat dau (VD: 00:01:30 hoac 90): "
set /p "END_TIME=Thoi gian ket thuc (VD: 00:02:45 hoac 165): "
echo.
echo Dang tien hanh cat video...
!BASE_CMD! --download-sections "*%START_TIME%-%END_TIME%" --force-keyframes-at-cuts -f "bv*+ba/b" --merge-output-format mp4 -o "%%(title)s_CUT.%%(ext)s" "%URL%"
echo.
pause
goto MainMenu

:DownloadSubtitle
echo.
set /p "URL=Dan link video vao day: "
if "%URL%"=="" goto MainMenu
echo.
echo Dang tai va ghep phu de...
!BASE_CMD! -f "bv*[height<=1080]+ba/b" --merge-output-format mkv --write-subs --write-auto-subs --sub-langs "vi,en" --embed-subs -o "%%(title)s_SUB.%%(ext)s" "%URL%"
echo.
pause
goto MainMenu

:DownloadSponsorBlock
echo.
set /p "URL=Dan link video vao day: "
if "%URL%"=="" goto MainMenu
echo.
echo Dang tai va cat bo quang cao/tai tro...
!BASE_CMD! -f "bv*[height<=1080]+ba/b" --merge-output-format mp4 --sponsorblock-remove all -o "%%(title)s_NoAds.%%(ext)s" "%URL%"
echo.
pause
goto MainMenu

:OpenFolder
echo.
echo Dang mo thu muc luu tru...
explorer "%DOWNLOAD_DIR%"
goto MainMenu

:UpdateTool
echo.
echo Dang kiem tra ban cap nhat tu Github...
yt-dlp -U
echo.
pause
goto MainMenu