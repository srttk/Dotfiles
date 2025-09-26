# List files include dot files and dirs
alias l="ls -la"

# CPU
alias cpu="top -F -R -o cpu"

# Youtube downloader
alias ytdl="yt-dlp"

# Volumes
alias vol="cd /volumes"

# Empty mac trash
alias empty="sudo rm -rf ~/.Trash/*"

# webm to mp4 converter
alias webm2mp4='f() { ffmpeg -i "$1" -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k "${1%.webm}.mp4" }; f'