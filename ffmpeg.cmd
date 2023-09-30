@echo off  & setLocal EnableDelayedExpansion

TITLE ffmpeg copy audio copy video

echo Input the file path
set /p "plex_folder="

set root_path="%~dp0"

for /f "tokens=*" %%b in ('%root_path:"=%win-x64\Tools\FfMpeg\bin\ffprobe.exe -v error -loglevel panic -show_entries stream^=avg_frame_rate -print_format flat -select_streams v "%plex_folder:"=%" 2^>^&1') do (
set ffprobe_output="%%b"
)
set ffprobe_output=!ffprobe_output:"=!
set ffprobe_output=!ffprobe_output:streams.stream.0.avg_frame_rate=!
rem streams.stream.0.avg_frame_rate=
:: remove first char the equals sign
set ffprobe_output=!ffprobe_output:~1!

"%root_path:"=%win-x64\Tools\FfMpeg\bin\ffmpeg.exe" -y -fflags +genpts -r %ffprobe_output% -i "%plex_folder:"=%" -c:v copy -map 0:v -r %ffprobe_output% "%plex_folder:"=%.h264"
"%root_path:"=%win-x64\Tools\FfMpeg\bin\ffmpeg.exe" -y -fflags +genpts -r %ffprobe_output% -i "%plex_folder:"=%.h264" -i "%plex_folder:"=%" -c:v copy -map 0:v -map 1:a? -map 1:s? -c:a copy -c:s copy "%plex_folder:"=%.mkv"

pause
