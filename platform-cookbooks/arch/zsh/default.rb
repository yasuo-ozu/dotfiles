package 'zsh'
dotfile '.zshrc'

execute "use /bin/zsh as a login shell of #{node[:user]}" do
	command "usermod -s \"/bin/zsh\" #{node[:user]}"
	not_if "grep #{node[:user]} /etc/passwd | cut -d: -f7"
end
execute "use /bin/zsh as a login shell of root" do
	command 'usermod -s "/bin/zsh" root'
	not_if 'grep root /etc/passwd | cut -d: -f7'
end
