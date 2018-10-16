
package 'pavucontrol'
package "pulseaudio"

execute "enable pulseaudio" do
	not_if "sudo -u #{node[:user]} -E -- systemctl --user is-enabled pulseaudio | grep -q enabled"
	command "sudo -u #{node[:user]} -E -- systemctl --user enable pulseaudio"
end
