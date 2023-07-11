
alias ti='timew'
alias tsw='timew summary :week :ids :annotations'
alias ts='timew summary :ids :annotations'
alias ta='task'
alias taa='task add'
alias tt='task +today'

alias n='nvim'

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


alias dops='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"'
