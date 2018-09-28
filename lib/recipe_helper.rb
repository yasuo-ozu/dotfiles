ROOT_DIR = File.expand_path('../..', __FILE__)
PLATFORM = node[:platform]
MItamae::RecipeContext.class_eval do
	def evacuate_file(f)
		backupfile = "#{f}.bak"
		if !File.exist?(backupfile) && !File.symlink?(backupfile) then
			File.rename(f, backupfile)
		else
			i = 0
			loop do
				if !File.exist?("#{backupfile}#{i}") && File.symlink?("#{backupfile}#{i}") then
					File.rename(f, "#{backupfile}#{i}")
					break
				end
				i += 1
			end
		end
	end
	# src: in ./conifg, dst in $HOME
	def create_link(src, dst)
		dirs = File.dirname(dst).split("/")
		ignore_dirs = ["/", "/home", "/root"]
		secure_dirs = %w(.cache .cups .dbus .gnupg .local .pki .ssh)
		fuser = node[:user]
		for i in 0...(dirs.length) do
			dir = dirs[0..i].join("/")
			next if dir == ""
			fuser = node[:user]
			fuser = "root" if i >= 1 && dirs[0] == "" && dirs[1] == "root"
			fuser = dirs[2] if i >= 2 && dirs[0] == "" && dirs[1] == "home"
			fmode = "0755"
			next if ignore_dirs.include?(dir)
			fmode = "0700" if i == 2 && dirs[0] == "" && dirs[1] == "home"
			for secure_dir in secure_dirs do
				fmode = "0700" if dirs.include?(secure_dir)
			end
			evacuate_file(dir) if File.exist?(dir) && File.lstat(dir).ftype != 'directory'
			directory dir do
				user	fuser
				owner	fuser
				group	fuser
				mode	fmode
			end
		end
		if File.exist?(dst) then
			evacuate_file(dst) if File.lstat(dst).ftype != 'link' || File.readlink(dst) != src
		end
		evacuate_file(dst) if File.symlink?(dst) && File.readlink(dst) != src
		evacuate_file(dst) if !File.symlink?(dst) && File.exist?(dst)
		link dst do
			to src
			user fuser
		end
	end

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
				command "cd \"#{File.join(ROOT_DIR, 'contrib', name)}\" && sudo -u \"#{node[:user]}\" makepkg -sf && pacman --noconfirm -U *.tar.xz"
				not_if "pacman -Qi \"#{name}\" > /dev/null"
			end
		else
			package('go')
			package_sp('yay')
			directory "#{ENV['HOME']}/.cache/yay" do
				user node[:user]
				owner node[:user]
				group node[:user]
			end
			execute "install #{name} from aur" do
				command "pacman --noconfirm -R sudo; yay --noconfirm -S \"#{name}\"; pacman --noconfirm -S sudo"
				not_if "pacman -Qi \"#{name}\" > /dev/null"
			end
		end
	end
end
