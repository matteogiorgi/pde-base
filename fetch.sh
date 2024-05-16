#!/usr/bin/env bash

# Simple bash script to display system information in a nice format.
# It is meant to be used as a welcome message for the shell (~/.bashrc).




### Info
########

MYNAME=$(whoami)
MYHOST=$(cat /proc/sys/kernel/hostname)
MYOSYS=$(. /etc/os-release; echo "${NAME}")
MYKERNEL=$(awk -F- '{print $1}' /proc/sys/kernel/osrelease)
MYSHELL=$(basename "${SHELL}")




### Palette
###########

C0='[00m'
C4='[1;34m'
C5='[1;35m'
C6='[1;36m'
C7='[1;37m'




### Output
##########

printf '%s\n' "${C5}    .-.     ${C4}${MYNAME}${C7}@${C4}${MYHOST}"
printf '%s\n' "${C5}    ${C7}OO${C5}|     ${C6}OS${C0}      ${MYOSYS}"
printf '%s\n' "${C5}   /  \     ${C6}Kernel${C0}  ${MYKERNEL}"
printf '%s\n' "${C5}  (\__/)    ${C6}Shell${C0}   ${MYSHELL}"
printf "\n"
