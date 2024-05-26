# ~/.bash_logout: executed by bash(1) when login shell exits.
# When leaving the console clear the screen to increase privacy
# ---
# The default script is located in /etc/bash.bash_logout


if [[ "$SHLVL" = 1 ]]; then
    [[ -x /usr/bin/clear_console ]] && /usr/bin/clear_console -q
fi
