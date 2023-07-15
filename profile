
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.scripts" ] && PATH="$HOME/.scripts:$PATH"

export XDG_RUNTIME_DIR=/tmp/$USER-$(uuidgen)
alias editor=vim

export TERMINAL="st"
export BROWSER="/usr/bin/firefox"
export FILE_MANAGER="/usr/bin/thunar"
export EMAIL_CLIENT="/usr/bin/thunderbird"
export EDITOR="/usr/bin/vim"

export XINITRC="$HOME/.config/sx/sxrc"
[ "$(fgconsole 2>/dev/null)" = "1" ] && exec sx
