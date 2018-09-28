package 'zsh'
dotfile '.zshrc'
`usermod -s "/bin/zsh" #{node[:user]}`
`usermod -s "/bin/zsh" root`
