
# GOPATH Env
GOPATH='~/Projects/go'
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH:

# Shortcuts #
# Projects directory
alias pro="cd ~/Projects"
# Go projects directory
alias gopro="cd ~/Projects/go/src/github.com/srttk"

alias webm2mp4='f() { ffmpeg -i "$1" -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k "${1%.webm}.mp4" }; f'
