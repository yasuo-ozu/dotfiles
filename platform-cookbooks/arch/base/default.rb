# pacman base group

package 'linux'
package 'base'
package 'linux-firmware'
package 'cryptsetup'
package 'device-mapper'
package 'dhcpcd'
package 'diffutils'
package 'e2fsprogs'
package 'jfsutils'
package 'less'
package 'logrotate'
package 'lvm2'
package 'man-db'
package 'man-pages'
package 'mdadm'
# package 'nano'
package 'netctl'
package 'perl'
package 'reiserfsprogs'
package 's-nail'
package 'sysfsutils'
package 'texinfo'
package 'usbutils'
# package 'vi'
package 'which'
package 'xfsprogs'

execute "add multilib to pacman.conf" do
	not_if 'cat /etc/pacman.conf | sed -e "/^#/d" | grep -q "[multilub]"'
	command '/bin/echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && pacman -Sy'
end

