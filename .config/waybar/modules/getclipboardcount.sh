#!/bin/bash
TTCOUNT=$((`clipman pick --tool STDOUT | wc -l`+1))
printf '{\"text\":\"%s\"}' $TTCOUNT
