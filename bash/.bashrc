# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files in the
# bash-doc package for examples.
# ---
# Bourne again shell - https://www.gnu.org/software/bash/




### Interactive mode
####################

case $- in
    *i*) ;;
    *) return;;
esac




### History & options
#####################

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
# ---
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar




### Lesspipe & chroot
#####################

if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi
# ---
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi




### Functions
#############

function __fetch_git_branch () {
    function __fetch_git_status () {
        [[ $(git status --porcelain 2>/dev/null) ]] && echo "*"
    }
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(__fetch_git_status))/"
}
# ---
function __ffind () {
    [[ -x "$(command -v fzy)" ]] || return
    while FJUMP="$(/usr/bin/ls -aF --ignore="." --ignore=".git" --group-directories-first | `
          `fzy -p "$PWD$(__fetch_git_branch " (%s)") > ")"; do
        if [[ -d "$FJUMP" || (-d "$FJUMP" && -L "$FJUMP") ]]; then
            cd "${FJUMP}" && continue || return
        fi
        case $(/usr/bin/file --mime-type "$FJUMP" -bL) in
            text/* | application/json) "${EDITOR:=vi}" "$FJUMP";;
            *) command xdg-open "$FJUMP" &>/dev/null
        esac
    done
}
# ---
function __fjump () {
    [[ -x "$(command -v fzy)" && -x "$(command -v tmux)" && -z "$TMUX" ]] || return
    if FPLEX="$(/usr/bin/find "$(pwd)" -type d -not -path '*/\.*' -exec realpath {} \; | `
          `fzy -p "$PWD$(__fetch_git_branch " (%s)") > ")"; then
        command tmux new-session -c "$FPLEX" -s "$(basename "$FPLEX")"
    fi
}




### Aliases
###########

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" \
"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# ---
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alFtr'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias xcopy='xclip-copyfile'
alias xpasta='xclip-pastefile'
alias xcut='xclip-cutfile'
alias stow='stow --stow'
alias restow='stow --restow'
alias unstow='stow --delete'
alias ff='__ffind'
alias fj='__fjump'




### PS1 (with color support)
############################

if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;90m\]\t\[\033[00m\] \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;94m\]\w\[\033[00m\]'
    [[ $(type -t __fetch_git_branch) == function ]] && PS1+='\[\033[01;33m\]$(__fetch_git_branch " (%s)")\[\033[00m\]\$ ' || PS1+='\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\t \u@\h:\w'
    [[ $(type -t __fetch_git_branch) == function ]] && PS1+='$(__fetch_git_branch " (%s)")\$ ' || PS1+='\$ '
fi




### Bash completion
###################

if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi




### Export env-variables
########################

export TERM='xterm-256color'
export SHELL='/usr/bin/bash'
export PAGER='/usr/bin/less -~'




### Color support
#################

export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;37m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# ---
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi




## Completion (no ~/.inputrc)
#############################

set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string "▘"'
bind 'set vi-cmd-mode-string "▖"'
# ---
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'
# ---
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
bind 'set completion-ignore-case on'
bind 'set completion-prefix-display-length 3'
bind 'set mark-symlinked-directories on'
bind 'set visible-stats on'
bind 'set colored-stats on'




### Keybindings (no ~/.inputrc)
###############################

bind -m vi-command -x '"\C-l": clear'
bind -m vi-insert -x '"\C-l": clear'




### Add more inside ~/.extrarc
##############################

if [[ -f "$HOME/.extrarc" ]]; then
    . "$HOME/.extrarc"
fi
