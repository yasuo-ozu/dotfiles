#!/bin/sh

WIFI_DEV=`ip route get 192.168.0.1 | head -n 1 | sed -e 's/^.*dev \([^ ]*\) .*$/\1/'`
if nmcli con show --active | grep -q "YamanakaLab"; then
	if [ "$1" = "vpn0" ]; then
		case "$2" in
		up|vpn-up)
			ip route add 192.168.0.0/24 dev "$WIFI_DEV" metric 10
			;;
		down|vpn-down)
			ip route del 192.168.0.0/24 dev "$WIFI_DEV" metric 10
			;;
		esac
	fi
fi
exit 0
