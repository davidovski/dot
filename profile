# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


if [ -d "$HOME/.scripts" ] ; then
    PATH="$HOME/.scripts:$PATH"
fi

#export LC_ALL="C"
#export TERMINAL="konsole --hide-menubar --profile qtile"
alias editor=vim
export TERMINAL="urxvt"
export BROWSER="/usr/bin/chromium"
export FILE_MANAGER="/usr/bin/thunar"
export EMAIL_CLIENT="/usr/bin/thunderbird"
export BLOG_DIR="/home/david/docs/proj/blog"
export EDITOR="/usr/bin/vim"

export ANDROID_SDK_ROOT=/opt/android-sdk
[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null

