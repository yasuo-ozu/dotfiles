package 'zsh'
dotfile '.zshrc'

directory '.local/share' do
	user node[:user]
	action :create
end

remote_directory '.local/share/runtex' do
	user node[:user]
	action :create
	source 'files/runtex'
end

execute "use /bin/zsh as a login shell of #{node[:user]}" do
	command "usermod -s \"/bin/zsh\" #{node[:user]}"
	not_if "grep #{node[:user]} /etc/passwd | cut -d: -f7 | grep -q /bin/zsh"
end
execute "use /bin/zsh as a login shell of root" do
	command 'usermod -s "/bin/zsh" root'
	not_if 'grep root /etc/passwd | cut -d: -f7 | grep -q /bin/zsh'
end
