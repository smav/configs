#!/bin/bash

# If server is on the network connect synergy, for laptop-desktop sharing

SERVER="10.0.0.100"
ping -c 1 ${SERVER} > /dev/null 2>&1
if [[ $? == 0 ]]; then
    # If ping returned ok/host is up
    # Check if synergy is running alreayd
    #
    #
    /usr/bin/synergyc -n w500 tao
fi
