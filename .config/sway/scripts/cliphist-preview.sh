#!/bin/bash

# Define the preview command
PREVIEW_CMD='
    # Get the selection, strip the ID, and identify
    val=$(cliphist decode <<< "{}")
    if [[ $(file -b --mime-type - <<< "$val") == image/* ]]; then
        cliphist decode <<< "{}" | chafa -s 60x20 -
    else
        cliphist decode <<< "{}" | head -n 20
    fi
'

# Run fzf
selected=$(cliphist list | fzf --no-sort --preview="$PREVIEW_CMD")

# Final action
if [ -n "$selected" ]; then
  cliphist decode <<<"$selected" | wl-copy
fi
