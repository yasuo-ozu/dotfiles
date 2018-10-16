HOME=ENV['HOME']
directory "#{HOME}/.config" do
	user node[:user]
	owner node[:user]
	group node[:user]
end
[ "#{HOME}/.gnupg", "#{HOME}/.ssh"].each do |dir|
	directory dir do
		owner node[:user]
		group node[:user]
		mode "700"
	end
end

package 'xdg-user-dirs'

execute 'create directories in home' do
	command 'LC_ALL=C xdg-user-dirs-update'
	user node[:user]
	not_if "[ -e \"#{HOME}/.config/user-dirs.dirs\" ]"
end

dotfile '.bashrc'
dotfile '.bash_profile'
dotfile '.profile'

