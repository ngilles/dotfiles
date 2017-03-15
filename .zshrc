# This zsh function is called whenever changing directories and
# shows the current git branch in the prompt
function precmd()
{
    # Adjust this to your current preferred prompt
    PROMPT="%n@%m"

    # Python virtual env
    if [ "z${VIRTUAL_ENV}" != "z" ]; then
        PROMPT="($(basename ${VIRTUAL_ENV})) ${PROMPT}"
    fi

    ## Add final character after the optional git branch (usually # or >)
    export PROMPT="$PROMPT: "
}

export RPROMPT=" (%~)"


# utility functions

# SVN short log 
svnll() { svn log "$@"|( read; while true; do read h||break; read; m=""; while read l; do echo "$l" | grep -q '^[-]\+$'&&break; [ -z "$m" ] && m=$l; done; echo "$h % $m" | sed 's#\(.*\) | \(.*\) | \([-0-9 :]\{16\}\).* % \(.*\)#\1\t\2\t(\3) \4#'; done)}

# Active virtualenvwrapper
# this used to be called at all the time, but kinda slow...
venv() {
    export WORKON_HOME=~/.virtualenvs
    VENVWRAPPER_BIN=$(which virtualenvwrapper.sh)
    if [ -f $VENVWRAPPER_BIN ]; then
        echo 'loading virtualenv wrapper...'
        . $(which virtualenvwrapper.sh)
    else
        echo 'virtualenv wrapper not found'
    fi
}


# aliases
alias vi=vim
alias svn-shortlog=svnll
alias ussh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"


# tmux util function to refresh useful env vars
refresh-env() {
    local _env_var
    while read _env_var; do
        if [[ $_env_var == -* ]]; then
            unset ${_env_var/#-/}
        else
            # quote the value
            _env_var=${_env_var:s/=/=\"}
            _env_var="${_env_var}\""
            eval export $_env_var
        fi
    done < <(tmux show-environment)
}


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
