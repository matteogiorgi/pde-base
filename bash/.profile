# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
# See /usr/share/doc/bash/examples/startup-files for examples,
# the files are located in the bash-doc package.
# ---
# The default umask is set in /etc/profile; for setting the umask for ssh logins,
# install and configure the libpam-umask package (umask 022)




### Bourn-Again Shell
#####################

if [ -n "$BASH_VERSION" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi




### $PATH (include ~/.local/bin)
################################

mkdir -p "$HOME/.local/bin"
PATH="$PATH:$HOME/.local/bin"




### Env-Variables
#################

export EDITOR="/usr/bin/vi"
export VISUAL="/usr/bin/vi"
