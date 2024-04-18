#!/usr/bin/env bash

# This '.debdot' setup script will install a minimal work environment complete
# with all the bells and whistles needed to start working properly.
# ---
# There are no worries of losing a potential old configuration: il will be
# stored in a separate folder in order to be restored manually if needed.




### Functions
#############

RED='\033[1;36m'
NC='\033[0m'
# ---
__warning () {
    if [ "$(id -u)" = 0 ]; then
        printf "\n${RED}%s${NC}"     "This script MUST NOT be run as root user since it makes changes"
        printf "\n${RED}%s${NC}"     "to the \$HOME directory of the \$USER executing this script."
        printf "\n${RED}%s${NC}"     "The \$HOME directory of the root user is, of course, '/root'."
        printf "\n${RED}%s${NC}"     "We don't want to mess around in there. So run this script as a"
        printf "\n${RED}%s${NC}\n\n" "normal user. You will be asked for a sudo password when necessary."
        exit 1
    fi
}
# ---
__restore () {
    if [[ ! -d "$HOME/.debdot_restore" ]]; then
        mkdir "$HOME/.debdot_restore"
        RESTORE="$HOME/.debdot_restore"
    else
        printf "${RED}%s${NC}\n" "'.debdot' is already set"
        exit 1
    fi
}
# ---
__error () {
    clear
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}
# ---
__clean () {
    if [[ -L $1 ]]; then
        unlink "$1"
    else
        mv "$1" "$RESTORE"
    fi
}
# ---
__backup () {
    [[ -f "$HOME/.bash_logout" ]] && _clean "$HOME/.bash_logout"
    [[ -f "$HOME/.bashrc" ]] && _clean "$HOME/.bashrc"
    [[ -f "$HOME/.profile" ]] && _clean "$HOME/.profile"
    # ---
    [[ -f "$HOME/.tmux.conf" ]] && _clean "$HOME/.tmux.conf"
    # ---
    [[ -f "$HOME/.vimrc" ]] && _clean "$HOME/.vimrc"
}




### Start
#########

clear
__warning
# ---
sudo apt-get update && sudo apt-get upgrade -qq -y || __error "syncing repos"
sudo apt-get install -qq -y  git stow xclip trash-cli fzy bash bash-completion \
    tmux vim-gtk3 wamerican fonts-firacode || __error "installing packages"
# ---
__restore
__backup
stow bash
stow tmux
stow vim




### Finish
##########

printf "${RED}%s${NC}\n" "setup complete"
