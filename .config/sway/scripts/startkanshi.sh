!#/bin/bash

killall kanshi
/usr/local/bin/kanshi 2>&1 | ts  > ~/.config/kanshi.log
