include_recipe 'recipe_helper'

define :dotfile, source: nil do
	source = params[:source] || params[:name]
	link File.join(ENV['HOME'], params[:name]) do
		to File.join(ROOT_DIR, "config", source)
		user node[:user]
	end
	link File.join('/root', params[:name]) do
		to File.join(ROOT_DIR, "config", source)
		user 'root'
	end
end

node.reverse_merge!(
	user: ENV['SUDO_USER'] || ENV['USER'],
)

include_role node[:hostname]
