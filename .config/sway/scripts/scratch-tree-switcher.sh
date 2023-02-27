#!/bin/bash
SCRIPTNAME=$(basename $0)
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
IFS=$'\n'

if [[ -n $THEME ]]; then
    fzf_color="--color=$THEME"
fi

# $THEME env variable set via sway config.

# check for env variable, if exists we are the
# forked shell, get the waiting string from the fifo
# and call fzf and sway from there.
prompt="Windows> "
header="Switch to which window?"
if [[ -n $fifo ]]; then
    str=$(cat $fifo)
    rm -rf $fifo

    selection=$(printf $str | fzf --header=$header --prompt="$prompt" $fzf_color)

    id=$(echo $selection | cut -d ":" -f1)
    if [[ -z $id ]]; then
        exit
    fi

    swaymsg "[con_id=$id]" focus
    exit
fi

windows=($(swaymsg -t get_tree | jq -r '.nodes[].nodes[] | select(.name=="__i3_scratch") | .floating_nodes[]| {id, app_id,name} | .id, .app_id, .name'))

str=""
columns=0
lines=0
for ((i=0; i<"${#windows[@]}"; i=i+3,lines++)); do
    id="${windows[i]}"
    app_id="${windows[i+1]}"
    name="${windows[i+2]}"

    building_string="$id:"
#    if [[ $app_id != "null" ]]; 
#    then
#        building_string="$building_string $app_id"
#    fi
    if [[ $name != "null" ]];
    then
        building_string="$building_string : $name"
    fi
    if [[ ${#building_string} -gt $columns ]];
    then
        str_largest="$building_string"
        columns=${#building_string}
    fi
    str="$str$building_string\n" 
done


# add some padding to the terminal for 
# lines and columns, for columns make sure
# we take the prompt into the padding consideration
lines=$((lines+3))
columns=$((columns+"${#header}"+5))
if [[ columns -gt 100 ]];
then
    columns=100
fi

fifo=/tmp/sts-$(date +%s)
mkfifo $fifo
#fifo=$fifo $SHELL -c "alacritty \
#    -o window.dimensions.columns=$columns \
#    -o window.dimensions.lines=$lines \
#    -o font.size=12.0 \
#    -o window.padding.x=20 \
#    -o window.padding.y=20 \
#    --title "fzf-switcher" \
#    -e $SCRIPTPATH/$SCRIPTNAME"&
fifo=$fifo $SHELL -c "foot \
  -T \"SCRATCH SWITCHER\" \
  $SCRIPTPATH/$SCRIPTNAME"&
echo -n $str > $fifo
