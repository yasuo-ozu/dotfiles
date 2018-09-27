HOME=ENV['HOME']
directory "~/.config"
[ "#{HOME}/.gnupg", "#{HOME}/.ssh"].each do |dir|
	directory dir do
		owner node[:user]
		group node[:user]
		mode "600"
	end
end

package 'xdg-user-dirs'

execute 'create directories in home' do
	command 'LC_ALL=C xdg-user-dirs-update'
	not_if '[ -e "#{HOME}/.config/user-dirs.dirs" ]'
end


