#!/bin/bash
init_devices=$(lsusb | awk '{print $6, $7, $8, $9, $10}')

while true; do
    current_devices=$(lsusb | awk '{print $6, $7, $8, $9, $10}')

    if [ "${current_devices[@]}" != "${init_devices[@]}" ]; then

        while read -r line; do
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$timestamp $line" >> usb_device_changes.log #outputs to file in directory where this script is run from
        done \
        <<< $(diff --old-line-format='REMOVED - %L' --new-line-format='ADDED - %L' \
        <(echo "$init_devices") <(echo "$current_devices") | \
        grep -E '^(REMOVED|ADDED)')

        init_devices="$current_devices"		
        sleep 1
    fi
sleep 0.5
done

