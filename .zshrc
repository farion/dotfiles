export ZSH=$HOME/.oh-my-zsh

export EDITOR=nvim

export LANG=de_DE.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ZSH_THEME="farion"
export NVM_LAZY_LOAD=true

plugins=(git mvn colorize github virtualenv pip python history zsh-autosuggestions docker docker-compose zsh-nvm)

source $ZSH/oh-my-zsh.sh

alias gs="git status"

#eval "$(starship init zsh)"

export PATH=$PATH:/home/frre/.cargo/bin

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc


export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

if [[ $TERM =~ "^foot" ]]; then
	clear-screen-keep-sb() {repeat $((LINES-1)); do echo; done; zle .clear-screen}
	zle -N clear-screen clear-screen-keep-sb
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/frre/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
eval "$(task --completion zsh)"
eval "$(direnv hook zsh)"
