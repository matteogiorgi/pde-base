#!/usr/bin/env bash

# This '.debdot' setup script will install a minimal work environment complete
# with all the bells and whistles needed to start working properly.
# ---
# There are no worries of losing a potential old configuration: il will be
# stored in a separate folder in order to be restored manually if needed.




### Check & Funcs
#################

RED='\033[1;36m'
NC='\033[0m'
# ---
if [[ -d "$HOME/.debdot_restore" ]]; then
    printf "\n${RED}%s${NC}"   "═══════ Warning: .debdot set ══════"
    printf "\n${RED}%s${NC}\n" "Remove it and run this script again"
    exit 1
fi
# ---
function warning-message () {
    if [[ "$(id -u)" = 0 ]]; then
        printf "\n${RED}%s${NC}"     "This script MUST NOT be run as root user since it makes changes"
        printf "\n${RED}%s${NC}"     "to the \$HOME directory of the \$USER executing this script."
        printf "\n${RED}%s${NC}"     "The \$HOME directory of the root user is, of course, '/root'."
        printf "\n${RED}%s${NC}"     "We don't want to mess around in there. So run this script as a"
        printf "\n${RED}%s${NC}\n\n" "normal user. You will be asked for a sudo password when necessary."
        exit 1
    fi
}
# ---
function error-echo () {
    clear -x
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}
# ---
function restore-debdot () {
    function backup-debdot () {
        if [[ -f "$1" ]]; then
            [[ ! -L "$1" ]] || mv "$1" "${RESTORE}" && command unlink "$1"
        fi
    }
    RESTORE="${HOME}/.debdot_restore" && mkdir "${RESTORE}"
    backup-debdot "${HOME}/.bash_logout"
    backup-debdot "${HOME}/.bashrc"
    backup-debdot "${HOME}/.profile"
    backup-debdot "${HOME}/.tmux.conf"
    backup-debdot "${HOME}/.vimrc"
}




### Start
#########

warning-message
sudo apt-get update && sudo apt-get upgrade -qq -y || error-echo "syncing repos"
sudo apt-get install -qq -y  git stow xclip trash-cli bash bash-completion tmux vim-gtk3 wamerican \
      fd-find fzy fonts-firacode input-remapper diodon || error-echo "installing packages"
# ---
restore-debdot
command stow bash tmux vim




### Finish
##########

printf "${RED}%s${NC}\n" "setup complete"
