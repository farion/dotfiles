#!/bin/bash 

OUTPUTS=($(swaymsg -t get_outputs | jq -r --unbuffered --compact-output '( sort_by(.rect.x) | .[] | select(.active == true) | .name  )'))

# $1 number of workspacego
# return output name
getDisplayByWorkspace() {
    echo $(swaymsg -t get_tree | jq -r --unbuffered --compact-output '(select(.name == "root") | .nodes[].nodes[] | select(.num == '$1') | .output)')
}

# $1 output 
# return index
getOutputIndex() {

     OUTPUT=$1
     for i in "${!OUTPUTS[@]}"; do
        if [[ "${OUTPUTS[$i]}" = "${OUTPUT}" ]]; then
            echo $i
            return
        fi
     done

     echo -1
}

# $1 output name
# return workspace number
getLastWorkspaceOnOutput() {
    echo $(swaymsg -t get_workspaces | jq -r --unbuffered --compact-output 'last(( .[] | select(.output == "'$1'") | .num ) )')
}

# $1 output name
# return workspace number
getFirstWorkspaceOnOutput() {
    echo $(swaymsg -t get_workspaces | jq -r --unbuffered --compact-output 'first(( .[] | select(.output == "'$1'") | .num ) )')

}


CUR_DISPLAY=$(swaymsg -t get_tree | jq -r --unbuffered --compact-output '
(
    select(.name == "root") |
        first(.focus[]) )')

CUR_WORKSPACE=$(swaymsg -t get_tree | jq -r --unbuffered --compact-output "
(
    select(.name == \"root\") |
    .nodes[] |
    select(.id == $CUR_DISPLAY) |
    .current_workspace)" | cut -f1 -d" ")

CUR_OUTPUT=$(getDisplayByWorkspace $CUR_WORKSPACE )

OUTPUTS=($(swaymsg -t get_outputs | jq  -r --unbuffered --compact-output '( sort_by(.rect.x) | .[] | select(.active == true) | .name )'))

goToWorkspace(){

    DIRECTION=$1
    TO_WORKSPACE=$2
    CUR_OUTPUT=$3

    if [ "$DIRECTION" == "prev" ]; then
        TO_WORKSPACE=$(expr $TO_WORKSPACE - 1)
    elif [ "$DIRECTION" == "next" ]; then
        TO_WORKSPACE=$(expr $TO_WORKSPACE + 1)
    fi

    if [ $TO_WORKSPACE -eq 11 ]; then
        OUTPUT_INDEX=$(getOutputIndex $CUR_OUTPUT)
        CAND_INDEX=$(expr $OUTPUT_INDEX + 1)
        if [ -n "${OUTPUTS[$CAND_INDEX]}" ]; then
             swaymsg workspace number $(getFirstWorkspaceOnOutput ${OUTPUTS[$CAND_INDEX]})
        fi
        return
    elif [ $TO_WORKSPACE -eq 0 ]; then
        OUTPUT_INDEX=$(getOutputIndex $CUR_OUTPUT)
        CAND_INDEX=$(expr $OUTPUT_INDEX - 1)
        if [ -n "${OUTPUTS[$CAND_INDEX]}" ]; then
            swaymsg workspace number $(getLastWorkspaceOnOutput ${OUTPUTS[$CAND_INDEX]})  
        fi
        return
    fi

    TO_OUTPUT=$(getDisplayByWorkspace $TO_WORKSPACE) 

    if [ "$TO_OUTPUT" == "$3" ]; then
        swaymsg workspace number $TO_WORKSPACE    
    else
        goToWorkspace $DIRECTION $TO_WORKSPACE $CUR_OUTPUT
    fi
}

goToWorkspace $1 $CUR_WORKSPACE $CUR_OUTPUT
