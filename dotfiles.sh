#!/bin/sh

config_dir="$HOME/.config"
scripts_dir="$HOME/.scripts/"

if [ -f /usr/local/lib/sh/colors.sh ]; then
    . /usr/local/lib/sh/colors.sh
fi

save () {
    if [ ! -z "$(git status --porcelain)" ]; then
        printf "${RED}!!! You have uncommitted changes. Please commit or stash them before saving.\n"
        return 1
    fi

    for c in $(ls config); do
        printf "${GRAY}Copying %s to repo...\n" "$c"
        cp -r "$config_dir/$c"/* "config/$c/"
    done

    cp -r "$scripts_dir"/* "scripts/"

    git status
}

load () {
    printf "${RED}!!! This will overwrite your current config files. Are you sure? (y/n) "
    read -r answer
    if [ "$answer" != "y" ]; then
        printf "Aborting...\n"
        return 1
    fi

    for c in $(ls config); do
        printf "${GRAY}Copying %s to repo...\n" "$c"
        cp -r "config/$c/"* "$config_dir/$c/"
    done

    cp -r scripts/* "$scripts_dir/"
}

usage () {
    printf "Saves or loads dotfiles to and from the repository.\n"
    printf "%s save${GRAY} - Saves the current dotfiles to the repository.\n" "$0"
    printf "%s load${GRAY} - Loads the dotfiles from the repository to $HOME.\n" "$0"
    printf "Usage: %s [save|load]\n" "$0"
}

case "$1" in
    save|load)
        $1
        ;;
    *)
        usage
        exit 1
        ;;
esac
