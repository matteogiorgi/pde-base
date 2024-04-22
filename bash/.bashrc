# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files in the
# bash-doc package for examples.
# ---
# Bourne again shell - https://www.gnu.org/software/bash/




### Interactive
###############

case $- in
    *i*) ;;
    *) return;;
esac




### History & Options
#####################

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
# ---
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar




### Lesspipe & Chroot
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

function git-branch () {
    function git-status () {
        [[ $(command git status --porcelain 2>/dev/null) ]] && echo "*"
    }
    command git branch --no-color 2>/dev/null | command sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(git-status))/"
}
# ---
function ffind () {
    [[ -x "$(command -v fzy)" ]] || return && command clear -x
    while FFIND="$(command ls -aF --ignore="." --ignore=".git" --group-directories-first | `
          `command fzy -l 99 -p "$(pwd | command sed "s|^$HOME|~|")$(git-branch "(%s)") > ")"; do
        FFIND="${FFIND%[@|*|/]}"
        [[ -d "$FFIND" ]] && { cd "$FFIND" || return; }
        [[ ! -f "$FFIND" || -d "$FFIND" ]] && continue
        case $(command file --mime-type "$FFIND" -bL) in
            text/* | application/json) "${EDITOR:=/usr/bin/vi}" "$FFIND";;
            *) command xdg-open "$FFIND" &>/dev/null;;
        esac
    done
}
# ---
function fjump () {
    [[ -x "$(command -v fzy)" ]] || return && command clear -x
    FJUMP="$(command find . -type d -not -path '*/\.*' -not -path '.' | sed 's|^\./||' | `
          `command fzy -l 99 -p "$(pwd | command sed "s|^$HOME|~|")$(git-branch "(%s)") > ")"
    [[ -d "$FJUMP" ]] && { cd "$FJUMP" || return; }
}
# ---
function fhook () {
    [[ -x "$(command -v tmux)" && -x "$(command -v fzy)" ]] || return
    [[ -z "$TMUX" ]] || { command tmux detach && return; } && command clear -x
    BASENAME="$(command basename "$PWD" | command cut -c 1-37)"
    SESSIONS="$(command tmux list-sessions -F '#{session_name}' 2>/dev/null)"
    SCOUNTER="$(command tmux list-sessions 2>/dev/null | wc -l)"
    if command tmux has-session -t "$BASENAME" 2>/dev/null; then
        FHOOK="$(echo "$SESSIONS" | command fzy -l 99 -p "tmux-sessions ($SCOUNTER) > ")"
        [[ -n "$FHOOK" ]] && command tmux attach -t "$FHOOK"
        return
    fi
    FHOOK="$( (echo "$BASENAME (new)"; echo "$SESSIONS") | command fzy -l 20 -p "tmux-sessions ($SCOUNTER) > " )"
    if [[ -n "$FHOOK" ]]; then
        [[ "$FHOOK" == "$BASENAME (new)"  ]] && { command tmux new-session -c "$PWD" -s "$BASENAME" && return; }
        command tmux attach -t "$FHOOK"
    fi
}
# ---
function fgit() {
    [[ -x "$(command -v git)" && -x "$(command -v fzy)" ]] || return && command clear -x
    [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] || { echo "not a git repo" && return; }
    while FGIT="$(command git log --graph --format="%h%d %s %cr" "$@" | `
          `command fzy -l 99 -p "$(pwd | command sed "s|^$HOME|~|")$(git-branch "(%s)") > ")"; do
        FGIT="$(echo "$FGIT" | grep -o '[a-f0-9]\{7\}')"
        command git diff "$FGIT"
        command clear -x
    done
}




### Aliases
###########

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" \
"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# ---
alias lf='ls -CF'
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




### PS1 (with color support)
############################

if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;90m\]\t\[\033[00m\] \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;94m\]\w\[\033[00m\]'
    PS1+='\[\033[01;33m\]$(git-branch "(%s)")\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\t \u@\h:\w'
    PS1+='$(git-branch "(%s)")\$ '
fi




### Completion
##############

if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi




### Env-variables
#################

export TERM='xterm-256color'
export SHELL='/usr/bin/bash'
export PAGER='/usr/bin/less -~'




### Color-support
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




## Mode & Binds (no ~/.inputrc)
###############################

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
# ---
bind -m vi-command -x '"\C-l": clear -x'
bind -m vi-insert -x '"\C-l": clear -x'




### Extra-source (~/.extrarc)
#############################

if [[ -f "$HOME/.extrarc" ]]; then
    . "$HOME/.extrarc"
fi
