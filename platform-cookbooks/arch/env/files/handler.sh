#!/bin/bash
# Default acpi script that takes an entry for all actions

case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF)
                logger 'PowerButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SLPB|SBTN)
                logger 'SleepButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        logger 'AC unpluged'
                        ;;
                    00000001)
                        logger 'AC pluged'
                        ;;
                esac
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)
                        logger 'Battery online'
                        ;;
                    00000001)
                        logger 'Battery offline'
                        ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        case "$3" in
            close)
                logger 'LID closed'
                XAUTHORITY=$(ps -C xinit -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p') xset -display :0 dpms force off
                ;;
            open)
                logger 'LID opened'
                XAUTHORITY=$(ps -C xinit -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p') xset -display :0 dpms force on
                ;;
            *)
                logger "ACPI action undefined: $3"
                ;;
    esac
    ;;
    button/volumedown)
        amixer sset Master '5%-'
        ;;
    button/volumeup)
        amixer sset Master '5%+'
        ;;
    button/screenlock)
        SCREEN_USER=`ps -aux | sed -ne '/dwm/p' | head -n 1 | cut -d " " -f 1`
        sudo -u $SCREEN_USER -- env DISPLAY=:0 /usr/bin/slock
        ;;
    button/mute)
        if amixer sget Master | tail -n 1 | grep -q "off"; then
            amixer sset Master on
            amixer sset Headphone on
        else
            amixer sset Master off
        fi
        ;;
    video/brightnessdown)
        /opt/brightness down
        ;;
    video/brightnessup)
        /opt/brightness up
        ;;
    video/switchmode)
        SCREEN_USER=`ps -aux | sed -ne '/dwm/p' | head -n 1 | cut -d " " -f 1`
        DPS=`sudo -u $SCREEN_USER -- env DISPLAY=:0 xrandr | sed -ne '/ connected/p' | cut -d " " -f 1`
        MONITORS=`sudo -u $SCREEN_USER -- env DISPLAY=:0 xrandr --listmonitors | head -n 1 | cut -d " " -f 2`
        if [ "$MONITORS" -eq 1 ]; then
            while read DP; do
                if [ ! "$DP" = eDP1 ]; then
                    sudo -u $SCREEN_USER -- env DISPLAY=:0 xrandr --output $DP --auto --above eDP1
                fi
            done <<< $DPS
        else
            while read DP; do
                if [ ! "$DP" = eDP1 ]; then
                    sudo -u $SCREEN_USER -- env DISPLAY=:0 xrandr --output $DP --off
                fi
            done <<< $DPS
        fi
        ;;
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac

# vim:set ts=4 sw=4 ft=sh et:
