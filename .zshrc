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


# Check keyboard
autoload zkbd

function zkbd_file() {
    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
    [[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
    return 1
}

[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd

keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
    zkbd
    keyfile=$(zkbd_file)
    ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
    source "${keyfile}"
else
    printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char


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
