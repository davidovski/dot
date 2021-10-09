alias cls="clear"
alias cp="cp -v"
alias gif-for-cli="gif-for-cli -l 0 -c █ --display-mode=truecolor"
alias cdu="cdu -s -dh"
alias dclock="tput civis; watch -t -n1 \"date +%T|toilet --font mono12\""
alias blank="tput civis ; clear ; read"
alias open="xdg-open 2>/dev/null"
alias sl="ls"
alias resettabletscale='tablet 8 156 1 4:3'
#alias settabletscale="tablet 8 156 2.5063 4:3"
alias settabletscale="tablet 18 155 2 4:3"

alias gosumemory-default="sudo /home/david/.local/share/gosumemory/gosumemory -path /home/david/.local/share/osu-wine/OSU/Songs"

alias yta="youtube-dl --no-mtime --add-metadata --write-thumbnail --no-check-certificate -x -f bestaudio/best"

alias suspend="i3lock-fancy -p -t ''; systemctl suspend"

alias nano="nvim"
alias vim="nvim"
#alias tablet2='tablet 18 156 2.4'

rfc() { (for f in */; do du -a "$f" | tail -n+2 | wc -l | xargs printf "%s\t$f\n" ; done) | sort -Vr ;}

pandoc-md () {
	pandoc --pdf-engine=xelatex --variable mainfont="Arial" --variable sansfont=Arial --from markdown -o `basename $1`.pdf $1 
}

mp4-gif () {
	ffmpeg -i $1 -r 15 -vf "scale=360:-1,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" $2
}

alias zth="zathura"
alias nb="nb --blog-dir $BLOG_DIR"
alias looking-glass-client="looking-glass-client -G input:rawMouse=yes input:escapekey=119 input:autocapture=yes -k -j"
alias show-keymap="vim qmk_firmware/keyboards/ergo42/keymaps/iksvo/keymap.c"


configure () {
	vim ~/.config/$1
}
