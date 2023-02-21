export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="farion"

plugins=(git mvn colorize github virtualenv pip python history ssh-agent zsh-autosuggestions docker docker-compose)
# disabled plugins fzf-tab

source $ZSH/oh-my-zsh.sh

# taskwarrior and timewarrior aliases
alias ti='timew'
alias tsw='timew summary :week :ids'
alias ts='timew summary :ids'
alias ta='task'
alias taa='task add'
alias tt='task +today'

setopt no_bare_glob_qual

# Java 
function setJavaVersion(){
  for i in `update-alternatives --list java`
  do
    escapedi=$(echo -n $i | sed 's/bin\/java/bin/g' | sed 's/\//\\\//g')
    PATH=$(echo -n $PATH | sed "s/$escapedi://g");
  done

  export PATH=$1/bin:$PATH
  export JAVA_HOME=$1
}

alias setZuluJdk13='setJavaVersion "/usr/lib/jvm/zulu13-ca-amd64"'
alias setZuluJdk11='setJavaVersion "/usr/lib/jvm/zulu11-ca-amd64"'
alias setZuluJdk8='setJavaVersion "/usr/lib/jvm/zulu8-ca-amd64"'
setZuluJdk11

#eval `dircolors`
alias ls='ls --color=auto '
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -lha'
alias dir='ls -lht | less'

#be faster
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias h='history'
alias df='df -h'
alias grep='grep --color --exclude-dir=.svn --exclude-dir=.git '

alias c=clear

alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'

export EDITOR=nvim

export LANG=de_DE.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH=$PATH:/opt/liquibase

alias dops='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"'

function doen(){
  docker exec -it $1 /bin/bash
}

alias sqlplus='rlwrap sqlplus'

h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# kdesrc-build #################################################################

## Add kdesrc-build to PATH
export PATH="/opt/repos/kde/src/kdesrc-build:$PATH"

## Autocomplete for kdesrc-run
function _comp-kdesrc-run
{
  local cur
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  # Complete only the first argument
  if [[ $COMP_CWORD != 1 ]]; then
    return 0
  fi

  # Retrieve build modules through kdesrc-run
  # If the exit status indicates failure, set the wordlist empty to avoid
  # unrelated messages.
  local modules
  if ! modules=$(kdesrc-run --list-installed);
  then
      modules=""
  fi

  # Return completions that match the current word
  COMPREPLY=( $(compgen -W "${modules}" -- "$cur") )

  return 0
}

## Register autocomplete function
#complete -o nospace -F _comp-kdesrc-run kdesrc-run

################################################################################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

source ~/.rvm/scripts/rvm

export PATH="$PATH:/usr/lib/cargo/bin"

lfcd () {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

bindkey -s '^o' 'lfcd\n' 
