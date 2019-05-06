# vim: set ft=sh :

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export DefaultIMModule=fcitx
export XMODIFIER=@im=fcitx
export XMODIFIERS=@im=fcitx

export LC_ALL=ja_JP.UTF-8

if xrandr | sed -ne '/eDP1/p' | grep -q 3840x2160; then
	xrandr --output eDP1 --mode 1920x1080
	xrandr --output eDP1 --brightness 0.7
fi

xmodmap -e "keycode 66 = Caps_Lock"
xmodmap -e "remove lock = Caps_Lock"

xsetroot -solid DarkSlateBlue

run_widget() {
	if which "$1" &> /dev/null; then
		killall -q "$1"
		while pgrep -u $UID -x "$1" &>/dev/null; do sleep .2; done
		$@ &
	fi
}

if ! which awesome &> /dev/null; then
	run_widget stalonetray
fi

run_widget volumeicon
run_widget nm-applet
run_widget fcitx

if which awesome &>/dev/null; then
	exec awesome
else
	while :; do
		STATUS=`/home/yasuo/.local/bin/statusline`
		xsetroot -name "$STATUS" || exit
		sleep 5
	done &

	while :; do
		dwm > /dev/null 2>&1
	done
fi
