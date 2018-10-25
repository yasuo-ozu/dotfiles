
package 'gvim'
package 'vim-runtime'
dotfile '.vimrc'
dotfile '.vim/template/latex.tex'
directory "#{ENV['HOME']}/.vim/swap" do
	user node[:user]
end
directory "#{ENV['HOME']}/.vim/temp" do
	user node[:user]
end

# install dein
dein_clone_path="#{ENV['HOME']}/.cache/dein/repos/github.com/Shougo/dein.vim"
execute "creating #{dein_clone_path}" do
	not_if "[ -d \"#{dein_clone_path}\" ]"
	command "mkdir -p \"#{dein_clone_path}\""
	user node[:user]
end

execute "cloning dein" do
	not_if "[ -d \"#{dein_clone_path}/.git\" ]"
	command "git clone https://github.com/Shougo/dein.vim #{dein_clone_path}"
	user node[:user]
end
