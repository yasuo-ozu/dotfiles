
include_cookbook 'base'
include_cookbook 'base-devel'
include_cookbook 'base-utils'
include_cookbook 'chromium'
include_cookbook 'deadbeef'
include_cookbook 'devel'
#include_cookbook 'docker'
#include_cookbook 'firefox'
include_cookbook 'fonts'
include_cookbook 'git'
#include_cookbook 'gnome-tools'
#include_cookbook 'golang'
include_cookbook 'home'
include_cookbook 'ime'
#include_cookbook 'jdk'
#include_cookbook 'joke'
include_cookbook 'networkmanager'
#include_cookbook 'nodejs'
#include_cookbook 'pulseaudio'
include_cookbook 'python'
#include_cookbook 'r'
include_cookbook 'ssh'
#include_cookbook 'texlive'
include_cookbook 'vim'
include_cookbook 'zsh'
include_cookbook 'dwm'
include_cookbook 'env'
include_cookbook 'yamanakalab'
include_cookbook 'gvfs'

#package 'gimp'
#package 'inkscape'
#package 'keepassxc'
#package 'pdfshuffler'
#package 'scilab'
#package 'virtualbox'
#package 'vlc'
#package 'wxmaxima'

#package_sp 'line-latest'
package_sp 'yay'
package 'alacritty'

dotfile '.local/bin'

remote_file "/etc/X11/xorg.conf.d/10-touchpad.conf" do
	mode "644"
	owner "root"
	group "root"
end
