#!/bin/sh

case "$1" in

    lock)

        betterlockscreen -l dimblur -- --timestr="%H:%M" --date-str="%A, %d %B" --clock --date-align=1 --time-align=1 --time-pos="960:500" --date-pos="960:580" --time-size=80 --date-size=28 --indicator --ind-pos="960:720"
	#i3lock -i /home/darckblack/Imágenes/wallpaper/wallpaper2.png

        ;;

    logout)

        i3-msg exit

        ;;

    suspend)

        systemctl suspend

        ;;

    hibernate)

        systemctl hibernate

        ;;

    reboot)

        systemctl reboot

        ;;

    shutdown)

        systemctl poweroff

        ;;

    *)

        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"

        exit 2
        
esac

exit 0
