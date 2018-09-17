ROOT_DIR = File.expand_path('../..', __FILE__)
PLATFORM = node[:platform]
ORIG_USER = ENV['ORIG_USER']
MItamae::RecipeContext.class_eval do
	def include_cookbook(name)
		puts "loading cookbook #{name}..."
		if File.exists?(File.join(ROOT_DIR, 'platform-cookbooks', PLATFORM, name))
			include_recipe File.join(ROOT_DIR, 'platform-cookbooks', PLATFORM, name, 'default')
		elsif File.exists?(File.join(ROOT_DIR, 'cookbooks', name))
			include_recipe File.join(ROOT_DIR, 'cookbooks', name, 'default')
		else
			raise "cookbook #{name} not found"
		end
	end

	def include_role(name)
		include_recipe File.join(ROOT_DIR, 'roles', name, 'default')
	end

	def package_sp(name)
		if File.exists?(File.join(ROOT_DIR, 'contrib', name))
			execute "install #{name} from contrib" do
				command "cd \"#{File.join(ROOT_DIR, 'contrib', name)}\" && sudo -u \"#{ORIG_USER}\" makepkg -sf && pacman --noconfirm -U *.tar.xz"
				not_if "pacman -Qi \"#{name}\" > /dev/null"
			end
		else
			package_sp('yay')
			execute "install #{name} from aur" do
				command "yay --noconfirm -S \"#{name}\""
				not_if "pacman -Qi \"#{name}\" > /dev/null"
			end
		end
	end
end
