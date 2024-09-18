#!/bin/bash

killall -q polybar

if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mybar --config=~/.config/polybar/config.ini &
    done
else
    polybar --reload mybar --config=~/.config/polybar/config.ini &
fi
