node.reverse_merge!(
	user: ENV['SUDO_USER'] || ENV['USER'],
)

include_recipe 'recipe_helper'
ROOT_DIR = File.expand_path("../..", __FILE__)

define :dotfile, source: nil do
	source = params[:source] || params[:name]
	create_link(File.join(ROOT_DIR, "config", source), File.join(ENV['HOME'], params[:name]))
	create_link(File.join(ROOT_DIR, "config", source), File.join("/root", params[:name]))
	#link File.join(ENV['HOME'], params[:name]) do
	#	to File.join(ROOT_DIR, "config", source)
	#	user node[:user]
	#end
	#link File.join('/root', params[:name]) do
	#	to File.join(ROOT_DIR, "config", source)
	#	user 'root'
	#end
end

include_role node[:hostname]
