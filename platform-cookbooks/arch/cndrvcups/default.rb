package "lib32-libxml2"
package 'cups'
package 'cups-pdf'
package_sp "cndrvcups-lb-bin"
package_sp "cndrvcups-lt"

service 'org.cups.cupsd.service' do
	action [:enable, :start]
end
