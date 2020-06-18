randpass(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}

export GPG_TTY="$(tty)"
#export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye
#alternative
#export GPG_TTY="$(tty)"
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#gpgconf --launch gpg-agent

source /etc/bash/bashrc.d/bash_completion.sh

rm() { command rm -i "$@"; }
cp() { command cp -i "$@"; }
mv() { command mv -i "$@"; }

function start_agent {
    echo "Initialising new SSH agent..."
    OLD_UMASK=$(umask 077); /usr/bin/ssh-agent | sed s/^echo/#echo/ > "${SSH_ENV}"; umask ${OLD_UMASK}
    echo succeeded
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# SSH_ENV="$HOME/.ssh/environment"
# Source SSH settings, if applicable
# if [ -f "${SSH_ENV}" ]; then
#    . "${SSH_ENV}" > /dev/null
#    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#        start_agent;
#    }
# else
#    start_agent;
# fi

alias eqf='equery f'
alias equ='equery u'
alias eqh='equery h'
alias eqa='equery a'
alias eqb='equery b'
alias eql='equery l'
alias eqd='equery d'
alias eqg='equery g'
alias eqc='equery c'
alias eqk='equery k'
alias eqm='equery m'
alias eqy='equery y'
alias eqs='equery s'
alias eqw='equery w'

