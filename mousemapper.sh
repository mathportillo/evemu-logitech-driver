#!/bin/bash

event_type=EV_KEY
action_type=POINTER_BUTTON
pressed="pressed,"

readarray -t devices <<<$(libinput list-devices | grep pointer -B3 | grep -o '/dev/input/event[1-9]*')

# COMMANDS MAP
BTN_EXTRA=(KEY_LEFTMETA KEY_PAGEUP)
BTN_SIDE=(KEY_LEFTMETA KEY_PAGEDOWN)

function pressKey(){
    device=$1; key=$2; value=$3
    echo "pressing ${key} ${value}"
    evemu-event /dev/input/${device} --sync --type ${event_type} --code ${key} --value ${value};
}

function pressCommand(){
    device=$1; button=$2; movement=$3
    var=$button[@]
    command=${!var}

    if [ ${movement} = ${pressed} ]; then
        for key in ${command}; do
            pressKey ${device} ${key} 1
        done
    else
        for key in ${command}; do
            pressKey ${device} ${key} 0
        done | tac
    fi
}

function parseEventLine(){
    device=$1
    action=$2
    button=$4
    movement=$6

    # compute only if right action
    if [ ${action} = ${action_type} ]; then
        pressCommand ${device} ${button} ${movement}
    fi
}

function mapDevice(){
    device=$1
    while read line; do
        parseEventLine ${line}
    done < <(evtest ${device} | grep 'value 9000[0-9]' -A1  --line-buffered | grep 'EV_KEY' --line-buffered | stdbuf -oL sed 's/[(),]//g' | stdbuf -oL awk -v d=${device} -v a=${action_type}  '{ print d, a, "NA", $9, "NA", $11 }' & )
}

for device in ${devices[@]}; do
    ( mapDevice ${device} ) &
done

wait
