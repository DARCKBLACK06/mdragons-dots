#!/usr/bin/env bash

step=5
min=5
max=100

current=$(brightnessctl g)
maxval=$(brightnessctl m)

percent=$(( current * 100 / maxval ))

if [ "$1" = "up" ] && [ $percent -lt $max ]; then
    brightnessctl set +${step}%
elif [ "$1" = "down" ] && [ $percent -gt $min ]; then
    brightnessctl set ${step}%-
fi
