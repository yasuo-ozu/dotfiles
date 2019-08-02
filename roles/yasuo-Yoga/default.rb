execute "kill pcspkr" do
	command "echo 'blacklist pcspkr' > /etc/modprobe.d/nobeep.conf"
	not_if "[ -e /etc/modprobe.d/nobeep.conf ]"
end

execute "set console font fot HiDPi" do
  command "echo -e 'FONT=latarcyrheb-sun32\nFONT_MAP=8859-2' >> /etc/vconsole.conf"
  not_if "cat /etc/vconsole.conf | grep -q '^FONT='"
end

package_sp 'yay'
include_cookbook 'base'
include_cookbook 'base-devel'
include_cookbook 'base-utils'
include_cookbook 'chromium'
#include_cookbook 'deadbeef'
include_cookbook 'devel'
#include_cookbook 'docker'
include_cookbook 'firefox'
include_cookbook 'fonts'
include_cookbook 'git'
include_cookbook 'gnome-tools'
include_cookbook 'golang'
include_cookbook 'home'
include_cookbook 'ime'
#include_cookbook 'jdk'
#include_cookbook 'joke'
include_cookbook 'networkmanager'
#include_cookbook 'nodejs'
include_cookbook 'pulseaudio'
include_cookbook 'python'
#include_cookbook 'r'
include_cookbook 'ssh'
include_cookbook 'texlive'
include_cookbook 'vim'
include_cookbook 'zsh'
#include_cookbook 'dwm'
include_cookbook 'awesome'
include_cookbook 'env'
#include_cookbook 'yamanakalab'
include_cookbook 'gvfs'
include_cookbook 'alacritty'
include_cookbook 'ocaml'

include_cookbook 'cndrvcups'
printer "Canon MF720C Series"
execute "place ppd file" do	
	user "root"	
    command "gzip -cd /usr/share/cups/model/CNCUPSMF720CZK.ppd.gz > /etc/cups/ppd/Canon_MF720C_Series.ppd ; chown root:cups /etc/cups/ppd/Canon_MF720C_Series.ppd ; chmod 0640 /etc/cups/ppd/Canon_MF720C_Series.ppd"	
    not_if "[ -f /etc/cups/ppd/Canon_MF720C_Series.ppd ]"	
end
printer "Virtual PDF Printer"

package 'gimp'
package 'inkscape'
package 'keepassxc'
#package 'pdfshuffler'
#package 'scilab'
package 'virtualbox'
package 'vlc'
#package 'wxmaxima'

#package_sp 'line-latest'
package_sp 'satysfi-git'

dotfile '.local/bin'

remote_file "/etc/X11/xorg.conf.d/10-touchpad.conf" do
	mode "644"
	owner "root"
	group "root"
end

remote_file "/etc/systemd/logind.conf" do
	mode "0644"
end

remote_file "/etc/systemd/timesyncd.conf" do
	mode "0644"
end

package "nautilus"
package "libwbclient"
package "gvfs-smb"
package "smbclient"

execute "setup ntp" do
	command "timedatectl set-ntp true"
	not_if "LANG=C timedatectl status | sed -ne '/NTP/p' | grep -q active"
end

package "libreoffice-fresh-ja"
