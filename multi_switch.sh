#!/bin/bash

# ------------------------------------- N E S P I P L U S -------------------------------------
# For NesPI+ & SuperPI Case by Retroflag
# Install raspi-gpio via "sudo apt install raspi-gpio", no sudo needed, reset, poweroff
# Get it from: http://www.retroflag.com
# Button Script by Cyperghost: https://github.com/crcerror
# ---------------------------------------------------------------------------------------------

function NESPiPlus() {

    #Set GPIOs
    [[ -z $1 || $1 == "-1" ]] && GPIO_resetswitch=2 || GPIO_resetswitch=$1
    [[ -z $2 || $2 == "-1" ]] && GPIO_powerswitch=3 || GPIO_powerswitch=$2
    [[ -z $3 || $3 == "-1" ]] && GPIO_poweronctrl=4 || GPIO_poweronctrl=$3
    [[ -z $4 || $4 == "-1" ]] && GPIO_lediodectrl=14 || GPIO_lediodectrl=$4

    # Init: Use raspi-gpio to set pullup resistors!
    raspi-gpio set $GPIO_resetswitch ip pu
    raspi-gpio set $GPIO_powerswitch ip pu
    raspi-gpio set $GPIO_poweronctrl op pn dh
    raspi-gpio set $GPIO_lediodectrl op dh

    until [[ $power == 0 ]]; do
        power=$(raspi-gpio get $GPIO_powerswitch | grep -c "level=1 fsel=0 func=INPUT")
        reset=$(raspi-gpio get $GPIO_resetswitch | grep -c "level=1 fsel=0 func=INPUT")

        if [[ $reset == 0 ]]; then
            sudo reboot
		fi

        sleep 1
    done

    # Flashes LED 4 Times on PowerOff
    for iteration in 1 2 3 4; do
        raspi-gpio set $GPIO_lediodectrl op dl
        sleep 0.25
        raspi-gpio set $GPIO_lediodectrl op dh
        sleep 0.25
    done

    # PowerOff LED
    # Poweroff PowerCtrl needs script placed to /lib/systemd/system-shutdown/
    raspi-gpio set $GPIO_lediodectrl op dl

    # regular shutoff
    sudo poweroff

}

# -------------------------------- M A I N - F U N C T I O N ----------------------------------

# Parameter processing
# only integers from 0-99 are valid!
# Unvalid entries are assigned as -1
function cli_parameter() {
    unset call
    local PARAMETER=$@
    for i in ${PARAMETER[@]}; do
        value="${CLI#*$i}"
        [[ $value != $PARAMETER ]] && value="${value%% *}" || value="-1"
        [[ $value =~ ^[0-9]{1,2}$ ]] || value="-1"
        call+=("$value")
    done
}

# -------------------------------- M A I N - P R O G R A M M ----------------------------------

CASE_SEL="${1^^}"
[[ ${2^^} == "HELP" ]] && HELP_ITEM="$CASE_SEL" && CASE_SEL="help"
shift
CLI="${*,,}"

case "$CASE_SEL" in

    "--NESPI+")
        cli_parameter resetbtn= powerbtn= powerctrl= ledctrl=
        NESPiPlus ${call[@]}
    ;;
esac
