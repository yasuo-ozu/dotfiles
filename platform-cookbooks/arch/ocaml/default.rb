
package 'opam'

execute "initialize opam and ~/.opam" do
	command 'opam init -n'
	user node[:user]
    not_if "[ -d \"${HOME}/.opam\" ]"
end

