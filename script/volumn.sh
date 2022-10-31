#!/bin/bash

# Volumn up
if [ $1 = "up" ]; then
   amixer -q set Master 5%+
   notify-send -u low -t 1000 -i 'volume' "Volume: $(amixer get Master | grep -m 1 -o '[0-9]*%')"
   exit 0
elif [ $1 = "down" ]; then
   amixer -q set Master 5%-
   notify-send -u low -t 1000 -i 'volume' "Volume:  $(amixer get Master | grep -m 1 -o '[0-9]*%')"
   exit 0
fi
exit 0
