
package 'networkmanager'
package 'network-manager-applet'
package 'networkmanager-openconnect'

service 'NetworkManager' do
	action [:enable, :start]
end
service 'NetworkManager-dispatcher' do
	action [:enable, :start]
end
remote_file '/etc/NetworkManager/dispatcher.d/waseda-proxy.sh'
