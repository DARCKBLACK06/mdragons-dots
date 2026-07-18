#!/bin/bash
asusctl battery info | grep -oP '\d+(?=%)' | xargs echo "Lim:"
