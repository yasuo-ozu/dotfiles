execute "set $XDG_CONFIG_HOME" do
	not_if 'cat /etc/profile | sed -e "/^#/d" | grep -q "XDG_CONFIG_HOME"'
	command 'echo "export XDG_CONFIG_HOME=$HOME" >> /etc/profile'
end

package "acpid"
service "acpid" do
	action [:enable, :start]
end

remote_file "/etc/acpi/handler.sh" do
	owner "root"
	group "root"
	mode "0744"
end
package 'alsa-utils'

remote_file "/opt/brightness" do
	owner "root"
	group "root"
	mode "0744"
end

remote_file "/etc/pam.d/passwd" do
	owner "root"
	group "root"
	mode "0644"
end

remote_file "/etc/pam.d/login" do
	owner "root"
	group "root"
	mode "0644"
end

execute "generate locale ja_JP.UTF-8" do
	not_if 'locale -a | grep -q "ja_JP.utf8"'
	command 'echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen'
end

execute "generate locale en_US.UTF-8" do
	not_if 'locale -a | grep -q "en_US.utf8"'
	command 'echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen'
end

package 'ntp'
package 'gnome-keyring'
