
package 'networkmanager'
package 'network-manager-applet'
package 'networkmanager-openconnect'

service 'NetworkManager' do
	action :enable
end
service 'NetworkManager-dispatcher' do
	action :enable
end


#remote_file '/etc/NetworkManager/dispatcher.d/waseda-proxy.sh' do
#	mode "0744"
#end

if !system("which netctl") or !system("netctl list | grep -q -e '^*'") then
  puts "running NetworkManager"
  service 'NetworkManager' do
      action :start
  end
  service 'NetworkManager-dispatcher' do
      action :start
  end
end
