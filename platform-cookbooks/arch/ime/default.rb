
package 'fcitx-mozc'
package 'fcitx-gtk3'
package 'fcitx-configtool'

execute "set mozc as current im" do
	user node[:user]
	command "mkdir -p #{ENV['HOME']}/fcitx; echo \"IMName=fcitx-keyboard-jp\" >> #{ENV['HOME']}/fcitx/profile"
	not_if "[ -f #{ENV['HOME']}/fcitx/profile ] && cat #{ENV['HOME']}/fcitx/profile | sed -e '/^#/d' | grep -q IMName"
end

execute "set xim setting" do
	user node[:user]
	command "mkdir -p #{ENV['HOME']}/fcitx/conf; echo \"UseOnTheSpotStyle=True\" >> #{ENV['HOME']}/fcitx/conf/fcitx-xim.config"
	not_if "[ -f \"#{ENV['HOME']}/fcitx/conf/fcitx-xim.config\" ] && cat #{ENV['HOME']}/fcitx/conf/fcitx-xim.config | sed -e '/^#/d' | grep -q UseOnTheSpotStyle"
end
