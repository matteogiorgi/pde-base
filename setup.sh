#!/usr/bin/env bash

# This 'pde-base' setup script will install a minimal work environment
# complete with all the bells and whistles needed to start working properly.
# ---
# There are no worries of losing a potential old configuration: il will be
# stored in a separate folder in order to be restored manually if needed.




### Check & Funcs
#################

RED='\033[1;36m'
NC='\033[0m'
# ---
if [[ -d "${HOME}/.pderestore-base" ]]; then
    printf "\n${RED}%s${NC}"   "══════════ Warning: pde-base already set ══════════"
    printf "\n${RED}%s${NC}\n" "Remove ~/.pderestore-base and run this script again"
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
    printf "${RED}ERROR: %s${NC}\n" "$1" >&2
    exit 1
}
# ---
function store-conf () {
    function backup-conf () {
        if [[ -f "$1" ]]; then
            if [[ -L "$1" ]]; then
                command unlink "$1"
            else
                mv "$1" "${RESTORE}/"
            fi
        fi
    }
    RESTORE="${HOME}/.pderestore-base" && command mkdir -p "${RESTORE}"
    backup-conf "${HOME}/.bash_logout"
    backup-conf "${HOME}/.bashrc"
    backup-conf "${HOME}/.profile"
    backup-conf "${HOME}/.tmux.conf"
    backup-conf "${HOME}/.vimrc"
    backup-conf "${HOME}/.local/bin/fetch.sh"
}




### Start
#########

warning-message
SCRIPTPATH="$( cd "$(command dirname "$0")" ; pwd -P )" || exit 1
"${SCRIPTPATH}/fetch.sh"
command sudo apt-get update && sudo apt-get upgrade -qq -y || error-echo "syncing repos"
command sudo apt-get install -qq -y git xclip trash-cli htop bash bash-completion python3 vim-gtk3 tmux \
      wamerican fd-find fzy fonts-firacode input-remapper diodon || error-echo "installing from apt"
# ---
store-conf
cp "${SCRIPTPATH}/bash/.bash_logout" "${HOME}/"
cp "${SCRIPTPATH}/bash/.bashrc" "${HOME}/"
cp "${SCRIPTPATH}/bash/.profile" "${HOME}/"
cp "${SCRIPTPATH}/tmux/.tmux.conf" "${HOME}/"
cp "${SCRIPTPATH}/vim/.vimrc" "${HOME}/"
# ---
command mkdir -p "${HOME}/.local/bin/"
cp "${SCRIPTPATH}/fetch.sh" "${HOME}/.local/bin/"




### Finish
##########

printf "${RED}%s${NC}\n" "setup complete"
