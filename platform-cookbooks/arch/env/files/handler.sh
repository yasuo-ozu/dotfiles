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
                ;;
            open)
                logger 'LID opened'
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
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac

# vim:set ts=4 sw=4 ft=sh et:
