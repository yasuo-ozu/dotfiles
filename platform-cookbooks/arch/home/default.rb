
package 'xdg-user-dirs'

execute 'create directories in home' do
	command 'LC_ALL=C xdg-user-dirs-update'
	not_if '[ -e "~/.config/user-dirs.dirs" ]'
end

