#!/bin/sh

configurations=( iocane bg bspwm cava neofetch mpd mpv ncmpcpp vim sxhkd polybar picom rofi )


save () {
    mkdir config
    for i in "${configurations[@]}"; do
        cp -r "$HOME/.config/$i" config/
    done

    rm -r scripts
    cp -r "$HOME/.scripts" scripts

    cp $HOME/.profile profile
    cp $HOME/.bashrc bashrc
    cp $HOME/.bash_aliases bash_aliases
    cp $HOME/.Xdefaults Xdefaults
    cp $HOME/.xinitrc xinitrc

    mkdir -p fonts/TTF
    cp -r /usr/share/fonts/ttf-mononoki fonts/
    cp /usr/share/fonts/TTF/Meslo\ LG\ M\ Regular\ Nerd\ Font\ Complete\ Mono.ttf fonts/TTF/
    mkdir -p fonts/noto-cjk
    cp -r /usr/share/fonts/noto-cjk/NotoSansCJK-Regular.ttc fonts/noto-cjk


    rm config/mpd/state
    rm config/vim/viminfo

}

load () {
    printf "\033[31mWARNING THIS WILL REPLACE EXISTING CONFIGURATIONS\n\033[0mTo proceed type 'confirm': "
    read confirmation

    if [[ $confirmation == "confirm" ]]; then 
        mkdir -p $HOME/.config
        cp -r config/* $HOME/.config
        mkdir -p $HOME/.scripts
        cp -r scripts/* $HOME/.scripts

        cp bashrc $HOME/.bashrc
        cp bash_aliases $HOME/.bash_aliases

        cp Xdefaults $HOME/.Xdefaults
        cp xinitrc $HOME/.xinitrc
        cp profile $HOME/.profile

        mkdir -p $HOME/.fonts
        cp -r fonts/* $HOME/.fonts

        echo "Copied configurations!"

    else
        echo cancelled
    fi
}

install () {
    PKG="yay -S "
    $PKG xorg xorg-xinit pulseaudio fzf bspwm cava neofetch mpd mpv ncmpcpp vim sxhkd polybar picom rofi rxvt-unicode

    ln -s /usr/bin/rofi /usr/bin/dmenu

}

case $1 in
    "load")
        load
        ;;
    "save")
        save
        ;;
    "install")
        install
        ;;
    *)
        echo "USAGE: $0 [load/save/install]"
        ;;
esac

