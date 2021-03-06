ROOT_DIR = File.expand_path('../..', __FILE__)
PLATFORM = node[:platform]
node[:available_printers] = nil
MItamae::RecipeContext.class_eval do
	def evacuate_file(f)
		backupfile = "#{f}.bak"
		basename = ""
		basename = $~[1] if f.match(/^\/home\/[^\/]+\/(.+)$/)
		basename = $~[1] if f.match(/^\/root\/(.+)$/)
		if basename != "" then
			skelfile = "/etc/skel/#{basename}"
			puts "skelfile: #{skelfile}, f: #{f}"
			if File.exist?(skelfile) && `diff "#{skelfile}" "#{f}" > /dev/null` then
				puts "deleting #{f}"
				File.delete(f)
				return
			end
			puts "do not delete #{f}"
		end
		if !File.exist?(backupfile) && !File.symlink?(backupfile) then
			File.rename(f, backupfile)
		else
			i = 0
			loop do
				if !File.exist?("#{backupfile}#{i}") && !File.symlink?("#{backupfile}#{i}") then
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
		if File.symlink?(dst) && File.readlink(dst) != src then
			evacuate_file(dst)
		elsif File.exist?(dst) && !File.symlink?(dst) then
			if !system("diff \"#{dst}\" \"#{src}\"") then
				evacuate_file(dst)
			else
				File.delete(dst)
			end
		end
		fmode = "0%o" % (File.stat(src).mode & 0777)
		link dst do
			to src
			user fuser
		end
		file dst do
			action :edit
			mode fmode
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
				user node[:user]
				command "yay --removemake --noconfirm -S \"#{name}\""
				not_if "pacman -Qi \"#{name}\" > /dev/null"
			end
		end
	end
	
	def printer(name, uri = nil)
      if node[:available_printers].nil?
        puts "running lpinfo..."
        available_printers = []
        printer_item = nil
        lpinfo_output = `env -u LC_TYPE -u LC_ALL -u LC_MESSAGES lpinfo -l -v`
        lpinfo_output.each_line{|line|
          line.lstrip!
          if line.start_with?("Device:")
            if !printer_item.nil?
              available_printers.insert(-1, printer_item)
            end
            printer_item = {}
            line.slice!(0,7)
          end
          line.lstrip!
          idx = line.index(" = ")
          prop = line.slice(0, idx)
          val = line.slice(idx + 3..line.length - 1)
          printer_item[prop] = val.chomp
        }
        if !printer_item.nil?
          available_printers.insert(-1, printer_item)
        end
        node[:available_printers] = available_printers
      end
      for item in node[:available_printers] do
        if !item["make-and-model"].nil? and !item["make-and-model"].index(name).nil?
          uri = item["uri"]
          break
        end
      end
      if ! uri.nil?
        execute "enable printer #{uri} as #{name}" do
          user "root"
          command "lpadmin -p \"#{name.gsub(/ /, "_")}\" -E -v \"#{uri}\""
        end
      end
    end
end
