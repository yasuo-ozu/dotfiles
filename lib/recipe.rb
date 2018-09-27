node.reverse_merge!(
	user: ENV['SUDO_USER'] || ENV['USER'],
)
include_recipe 'recipe_helper'
ROOT_DIR = File.expand_path("../..", __FILE__)
CONFIG_DIR = "#{ROOT_DIR}/config"

define :dotfile, source: nil do
	name= params[:source] || params[:name]
	target = "#{CONFIG_DIR}/#{name}"
	if File.lstat(target).ftype == "directory" then
		pwd = Dir.pwd
		Dir.chdir(target)
		Dir.glob(["**/*", "**/.*"]) { |path|
			next if path == "." || path == ".."
			create_link("#{target}/#{path}", "#{ENV['HOME']}/#{name}/#{path}")
			create_link("#{target}/#{path}", "/root/#{name}/#{path}")
		}
		Dir.chdir(pwd)
	else
		create_link(target, "#{ENV['HOME']}/#{name}")
		create_link(target, "/root/#{name}")
	end
end

include_role node[:hostname]
