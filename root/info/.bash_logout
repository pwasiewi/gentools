# /etc/skel/.bash_logout

# This file is sourced when a login shell terminates.

# Clear the screen for security's sake.

gpgconf --kill gpg-agent >/dev/null 2>&1

if [ -n "${SSH_AGENT_PID}" ]; then
        eval "$(ssh-agent -s -k)"
fi
killall -9 agent
killall -9 baloo_file

clear
