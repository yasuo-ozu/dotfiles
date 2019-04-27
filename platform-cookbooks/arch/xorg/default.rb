package "xf86-video-intel"
package "xorg-server"
package "xorg-apps"
package "xorg-xinit"
package "xorg-xrandr"
package "xorg-xsetroot"
package "xorg-xev"
package "xorg-xdm"
package "xorg-xdpyinfo"

dotfile ".xinitrc"
dotfile ".Xdefaults"
dotfile ".xsession"

service "xdm" do
	action :enable
end

execute "set X11 keymap" do
	not_if 'localectl status | sed -ne "/X11 Layout/p" | grep -q jp'
	command 'localectl set-x11-keymap jp'
end

package 'slock'
remote_file "/etc/systemd/system/slock@.service"
service "slock@#{node[:user]}" do
	action :enable
end
