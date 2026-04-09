#!/usr/bin/env bash
#!/bin/bash

#wallpaper="$HOME/Imágenes/wallpaper/104359432_p0.jpg"
wallpaper="$HOME/Imágenes/wallpaper/wallpaper2.png"


case $1 in

    random)

        aleatory=`find ~/Imágenes/wallpaper -type f | shuf -n 1`

        cp /dev/null ~/.config/i3/scripts/.log-wallpaper

        echo $aleatory > ~/.config/i3/scripts/.log-wallpaper

        feh --bg-fill $aleatory --no-fehbg

    ;;



	 pywal)
		if [ -f ~/.config/i3/scripts/.log-wallpaper ]
    then
        log=`cat ~/.config/i3/scripts/.log-wallpaper`
        /home/darckblack/.local/bin/wal -i $log -n
    else
        /home/darckblack/.local/bin/wal -i $wallpaper -n
    fi
    ~/.config/i3/scripts/apply-wal-cava.sh
    bash ~/.config/i3/scripts/restart-glava.sh &
    sleep 1.5 && ~/.config/i3/polybar/launch.sh &
    betterlockscreen -u $(cat ~/.config/i3/scripts/.log-wallpaper) &
 	;;

    image-edit)

        kitty -e nvim ~/.config/i3/scripts/wallpaper-desktop.sh

    ;;

    delete-log)

        if [ -f ~/.config/i3/scripts/.log-wallpaper ]
        then

            rm ~/.config/i3/scripts/.log-wallpaper

        fi

    ;;

    default)
        if [ -f ~/.config/i3/scripts/.log-wallpaper ]
        then
            log=`cat ~/.config/i3/scripts/.log-wallpaper`
            feh --bg-fill $log --no-fehbg
            /home/darckblack/.local/bin/wal -i $log -n -q
        else
            echo $wallpaper > ~/.config/i3/scripts/.log-wallpaper
            feh --bg-fill $wallpaper --no-fehbg
            /home/darckblack/.local/bin/wal -i $wallpaper -n -q
        fi
        ~/.config/i3/scripts/apply-wal-cava.sh
        sleep 2 && ~/.config/i3/polybar/launch.sh &
        bash ~/.config/i3/scripts/restart-glava.sh &
    ;;

    center)

        if [ -f ~/.config/i3/scripts/.log-wallpaper ]
        then

            log=`cat ~/.config/i3/scripts/.log-wallpaper`

            feh --bg-center $log --no-fehbg

        else

            feh --bg-center $wallpaper --no-fehbg

        fi

    ;;

    extended)

        if [ -f ~/.config/i3/scripts/.log-wallpaper ]
        then

            log=`cat ~/.config/i3/scripts/.log-wallpaper`

            feh --bg-fill $log --no-fehbg

        else

            feh --bg-fill $wallpaper --no-fehbg
    sleep 0.5 && ~/.config/i3/polybar/launch.sh &

        fi

    ;;

    max)

        if [ -f ~/.config/i3/scripts/.log-wallpaper ]
        then

            log=`cat ~/.config/i3/scripts/.log-wallpaper`

            feh --bg-max $log --no-fehbg

        else

            feh --bg-max $wallpaper --no-fehbg

        fi

    ;;

    scale)

        if [ -f ~/.config/i3/scripts/.log-wallpaper ]
        then

            log=`cat ~/.config/i3/scripts/.log-wallpaper`

            feh --bg-scale $log --no-fehbg

        else

            feh --bg-scale $wallpaper --no-fehbg

        fi

    ;;

    repeat)

        if [ -f ~/.config/i3/scripts/.log-wallpaper ]
        then

            log=`cat ~/.config/i3/scripts/.log-wallpaper`

            feh --bg-tile $log --no-fehbg

        else

            feh --bg-tile $wallpaper --no-fehbg

        fi

    ;;


    *)
        echo "No aplica el valor ingresado"

    ;;

esac
