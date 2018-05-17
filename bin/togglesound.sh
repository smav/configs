#!/bin/bash

# http://unix.stackexchange.com/questions/65246/change-pulseaudio-input-output-from-shell#67398

# Sinks dont work on my setuip, so I need to mess with card profiles:
# speakers+headset mic =>
#       Active Profile: output:iec958-stereo+input:analog-stereo
# headphones+headset mic =>
#       Active Profile: output:analog-stereo+input:analog-stereo

# 2 Cards, 0 = nvidia hdmi, 1 = intel/mobo audio
CARD="1"
HEADPHONES="output:analog-stereo+input:analog-stereo"
SPEAKERS="output:iec958-stereo+input:analog-stereo"

# 2 cards so we need to mess about, ignore the first entry, grab 2nd's config:
# CurrentProfile should give : output:analog-stereo+input:analog-stereo
CURRENT=$(/usr/bin/pactl list cards | grep Active | tail -n1 | cut -d" " -f3)

if [[ ${CURRENT} == ${SPEAKERS} ]]; then
	/usr/bin/pactl set-card-profile 1 ${HEADPHONES}
	printf "\nHeadphones\n\n"
else
	/usr/bin/pactl set-card-profile 1 ${SPEAKERS}
	printf "\nSpeakers\n\n"
fi
