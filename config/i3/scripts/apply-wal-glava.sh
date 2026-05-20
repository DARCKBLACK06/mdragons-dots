#!/bin/bash
sudo sed -i "s|#define COLOR (.*|$(cat ~/.cache/wal/colors-glava)|" /usr/share/glava/bars.glsl
pkill glava
sleep 0.5
glava -d &
