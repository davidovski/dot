xrdb ~/.Xdefaults
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
exec bspwm

