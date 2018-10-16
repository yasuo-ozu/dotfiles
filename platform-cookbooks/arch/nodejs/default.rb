
package 'nodejs'
package 'npm'

execute "install gulp" do
	not_if 'npm -g list gulp'
	command 'npm -g install gulp'
end

execute "install nodemon" do
	not_if 'npm -g list nodemon'
	command 'npm -g install nodemon'
end
