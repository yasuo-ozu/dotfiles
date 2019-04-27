# vim: set ft=sh :

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export DefaultIMModule=fcitx
export XMODIFIER=@im=fcitx
export XMODIFIERS=@im=fcitx

export LC_ALL=ja_JP.UTF-8
fcitx &

if xrandr | sed -ne '/eDP1/p' | grep -q 3840x2160; then
	xrandr --output eDP1 --mode 1920x1080
fi
	

xmodmap -e "keycode 66 = Caps_Lock"
xmodmap -e "remove lock = Caps_Lock"

xsetroot -solid DarkSlateBlue

stalonetray &
nm-applet &

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
