#!/bin/sh
#
# Setup a work space called `work` with two windows
# first window has 3 panes. 
# The first pane set at 65%, split horizontally, set to api root and running vim
# pane 2 is split at 25% and running redis-server 
# pane 3 is set to api root and bash prompt.
# note: `api` aliased to `cd ~/path/to/work`
#
session="work"

# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s $session #-n "watch -t -n 5 timew summary :ids"

# Select pane 1, set dir to api, run vim
tmux selectp -t 1 
tmux send-keys "watch -t -n 5 timew summary :ids" C-m 

tmux splitw -v -p 180
tmux selectp -t 2
tmux send-keys "task" C-m 

tmux split-window -hf
#tmux splitw -h -p 35
tmux selectp -t 3
tmux send-keys "btop" C-m 

#tmux selectp -t 1
#tmux splitw -v -p 75
#tmux selectp -t 3
#tmux send-keys "task" C-m 

# Split pane 1 horizontal by 65%, start redis-server
# Select pane 2 
#tmux selectp -t 2
# Split pane 2 vertiacally by 25%
#tmux splitw -v -p 75

# select pane 3, set to api root
#tmux selectp -t 3
#tmux send-keys "task" C-m 

# Select pane 1
tmux selectp -t 1

# create a new window called scratch
tmux new-window -t $session:1 -n scratch

# return to main vim window
tmux select-window -t $session:0

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
