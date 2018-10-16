execute "add multilib to pacman.conf" do
	not_if 'cat /etc/pacman.conf | sed -e "/^#/d" | grep -q "[multilub]"'
	command '/bin/echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && pacman -Sy'
end

package_sp 'cndrvcups-lb'
package 'cups'
package 'cups-pdf'

remote_file "/etc/cups/ppd/Canon_LBP5910_16.ppd"
remote_file "/etc/cups/ppd/Canon_LBP5910_17.ppd"
remote_file "/etc/cups/ppd/Canon_iR-ADV_C5250_5255_LIPSLX.ppd"


service 'org.cups.cupsd.service' do
	action [:enable, :start]
end


