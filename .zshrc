export ZSH=$HOME/.oh-my-zsh

export EDITOR=nvim

export LANG=de_DE.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ZSH_THEME="farion"
export NVM_LAZY_LOAD=true

plugins=(git mvn colorize github virtualenv pip python history ssh-agent zsh-autosuggestions docker docker-compose zsh-nvm)

source $ZSH/oh-my-zsh.sh

alias gs="git status"

#eval "$(starship init zsh)"

export PATH=$PATH:/home/frre/.cargo/bin
