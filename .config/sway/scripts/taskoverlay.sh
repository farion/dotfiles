#!/bin/bash
swaymsg "workspace 3"
swaymsg "exec foot -T Performance -a \"TO_BTop\" zsh -c \"btop\"" &
sleep 0.3s
swaymsg "split horizontal"
swaymsg "exec foot -T Timetracking -a \"TO_Timew\" zsh -c \"while true; do clear; timetracking_sum_today; sleep 5;  done\"" &
sleep 0.3s
swaymsg "split vertical"
swaymsg "exec foot -T Tasks -a \"TO_Task\" zsh -c \"while true; do clear; obsidian_tasks; sleep 20;  done\"" &
sleep 0.3s
swaymsg "split vertical"
swaymsg "exec foot -T Command -a \"TO_Cmd\"" &
sleep 0.3s
swaymsg "[app_id=TO_Timew] focus"
swaymsg "split horizontal"
swaymsg "exec foot -T TimetrackingSum -a \"TO_TimewS\" zsh -c \"while true; do clear; timetracking_aggregate --from_date today; sleep 5; done\"" &
sleep 0.3
swaymsg "[app_id=TO_Task] focus"
swaymsg "split horizontal"
swaymsg "exec foot -T TimeDialog -a \"TO_TimeDialog\" zsh -c \"~/.config/sway/scripts/timetracking.sh\"" &
sleep 0.3s
swaymsg "[app_id=TO_Timew] resize set width 100ppt height 55ppt"
swaymsg "[app_id=TO_Tasks] resize set width 65ppt height 50ppt"
swaymsg "[app_id=TO_Cmd] resize set height 600ppt"
swaymsg "[app_id=TO_Cmd] focus"

#swaymsg "[app_id=TO_Timew] resize set width 50ppt height 30ppt"
#swaymsg "[app_id=TO_Task] resize set width 50ppt height 30ppt"
#swaymsg "[app_id=TO_Timew] resize set width 50ppt height 100ppt, move window to workspace 3"
#swaymsg "[app_id=TO_Task] resize set width 50ppt height 100ppt, move window to workspace 3"
#swaymsg "[app_id=TO_BTop] resize set width 50ppt height 99ppt, move window to workspace 3"
#swaymsg "[app_id=TO_Cmd] resize set width 50ppt height 100ppt, move window to workspace 3"
#swaymsg "[workspace=3] move workspace to eDP-1"
