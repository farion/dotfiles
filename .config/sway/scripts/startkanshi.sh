#!/bin/bash

killall kanshi || true
kanshi 2>&1 | ts >~/.config/kanshi.log
