#!/bin/bash

cd $(dirname "${0}")

source ../_common.sh

function customize_bash {
	me_restore_from_original /home/me/.bashrc

	run_as_me bash -c "cat /home/me/.bashrc data/.bashrc > /home/me/.bashrc.cat"

	run_as_me mv /home/me/.bashrc.cat /home/me/.bashrc
}

function customize_cryptsetup {
	local default_luks_device="$(lsblk -lo PATH,FSTYPE | grep crypto_LUKS | awk '{print $1}')"

	echo "ALL ALL=NOPASSWD: /sbin/cryptsetup" > /etc/sudoers.d/cryptsetup
}

function customize_git {
	run_as_me cp data/.gitconfig /home/me

	if [ ! -e /usr/local/bin/git-new-workdir ]
	then
		download https://raw.githubusercontent.com/git/git/master/contrib/workdir/git-new-workdir

		chmod a+x data/git-new-workdir

		cp data/git-new-workdir /usr/local/bin
	fi

	run_as_me cp data/gc_repositories /home/me/dev/projects
	run_as_me cp data/prepare_repositories /home/me/dev/projects
}

function customize_hostname {
	if [ $(hostname) == "fedora" ] ||
	   [ $(hostname) == "localhost.localdomain" ]
	then
		hostnamectl set-hostname liferay-$(random_letter)$(random_digit)$(random_letter)$(random_digit)$(random_letter)$(random_digit)$(random_letter)$(random_digit)
	fi
}

function customize_hosts {
	restore_from_original /etc/hosts

	for i in {1..9}
	do
		echo "127.0.0.1 test-virtual-host-${i}.com" >> /etc/hosts
	done
}

function customize_login {
	restore_from_original /etc/lxdm/PreLogin

	restore_from_original /etc/lxdm/PostLogin

	echo "/bin/bash -c \"/usr/bin/sudo /usr/local/bin/swap_caps_and_control\"" >> /etc/lxdm/PostLogin
	echo "/bin/bash -c \"/usr/bin/sudo /usr/local/bin/xrandr_monitor\"" >> /etc/lxdm/PostLogin
	echo "/bin/bash /home/me/dev/projects/liferay-basic-training/dotfiles/check_device.sh" >> /etc/lxdm/PostLogin
	echo "/bin/bash /usr/local/bin/xinput_logitech_mouse" >> /etc/lxdm/PostLogin
	echo "/bin/bash /usr/local/bin/xinput_touchpad" >> /etc/lxdm/PostLogin
	echo "/bin/bash /usr/local/bin/xset_screensaver" >> /etc/lxdm/PostLogin
}

function customize_lxdm {
	restore_from_original /etc/lxdm/lxdm.conf

	sed -i "s@# session=/usr/bin/startlxde@session=/usr/bin/openbox-session@" /etc/lxdm/lxdm.conf
	sed -i "s@bottom_pane=1@bottom_pane=0@" /etc/lxdm/lxdm.conf
	sed -i "s@disable=0@disable=1@" /etc/lxdm/lxdm.conf
	sed -i "s@gtk_theme=Clearlooks@gtk_theme=Adwaita-dark@" /etc/lxdm/lxdm.conf
	sed -i "s@lang=1@lang=0@" /etc/lxdm/lxdm.conf
	sed -i "s@theme=Industrial@theme=@" /etc/lxdm/lxdm.conf

	restore_from_original /usr/share/backgrounds/default.png

	#
	# https://upload.wikimedia.org/wikipedia/commons/7/71/Black.png
	#

	mv data/black.png /usr/share/backgrounds/default.png
}

function customize_notifications {
	echo "[D-BUS Service]" > /usr/share/dbus-1/services/org.freedesktop.Notifications.service
	echo "Exec=/usr/libexec/notification-daemon" >> /usr/share/dbus-1/services/org.freedesktop.Notifications.service
	echo "Name=org.freedesktop.Notifications" >> /usr/share/dbus-1/services/org.freedesktop.Notifications.service
}

function customize_openbox {

	#
	# Autostart
	#

	run_as_me mkdir -p /home/me/.config/openbox

	echo "#!/bin/bash" > /home/me/.config/openbox/autostart.sh
	echo "" >> /home/me/.config/openbox/autostart.sh
	echo "conky" >> /home/me/.config/openbox/autostart.sh
	echo "xautolock -time 5 -locker slock &" >> /home/me/.config/openbox/autostart.sh
	echo "xsetroot -solid black" >> /home/me/.config/openbox/autostart.sh

	chmod a+x /home/me/.config/openbox/autostart.sh

	#
	# Desktops
	#

	cp -f /etc/xdg/openbox/rc.xml /home/me/.config/openbox/rc.xml

	sed -i "s@manageDesktops>yes</manageDesktops@manageDesktops>no</manageDesktops@" /home/me/.config/openbox/rc.xml
	sed -i "s@number>4</number@number>3</number@" /home/me/.config/openbox/rc.xml

	#
	# Key Bindings
	#

	#
	# https://ubuntu-mate.community/t/error-cannot-autolaunch-d-bus-without-x11-display/11928
	#

	dbus-launch gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"

	run_as_me dbus-launch gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"

	perl -0777 -pi -e 's@<keybind key="A-space">(\n *<[^/].*)*\n *</keybind>@<!--$&-->@' /home/me/.config/openbox/rc.xml

	sed -i "s/A-Tab/W-Tab/" /home/me/.config/openbox/rc.xml
	sed -i "s/A-S-Tab/W-S-Tab/" /home/me/.config/openbox/rc.xml
	sed -i "s/W-F1/W-1/" /home/me/.config/openbox/rc.xml
	sed -i "s/W-F2/W-2/" /home/me/.config/openbox/rc.xml
	sed -i "s/W-F3/W-3/" /home/me/.config/openbox/rc.xml

	local openboxRCKeyBindings=$(cat data/openbox_rc_key_bindings.xml | tr '\n' ';' | sed 's/;/\\n/g')

	sed -i "s@</keyboard>@${openboxRCKeyBindings}\n</keyboard>@" /home/me/.config/openbox/rc.xml

	cp data/brightness_update /usr/local/bin/brightness_update

	echo "ALL ALL=NOPASSWD: /usr/local/bin/brightness_update" > /etc/sudoers.d/brightness_update

	#
	# Fonts
	#

	#sed -i "s/sans/Lucida Grande Medium/g" /home/me/.config/openbox/rc.xml

	#
	# Icons - Logout
	#

	#
	# https://www.onlinewebfonts.com/icon/115458
	#

	echo "[Desktop Entry]" > /usr/share/applications/logout.desktop
	echo "Exec=openbox --exit" >> /usr/share/applications/logout.desktop
	echo "Icon=/usr/share/applications/logout.png" >> /usr/share/applications/logout.desktop
	echo "Name=Logout" >> /usr/share/applications/logout.desktop
	echo "Terminal=false" >> /usr/share/applications/logout.desktop
	echo "Type=Application" >> /usr/share/applications/logout.desktop

	cp data/logout.png /usr/share/applications

	#
	# Icons - Reboot
	#

	echo "[Desktop Entry]" > /usr/share/applications/reboot.desktop
	echo "Exec=reboot" >> /usr/share/applications/reboot.desktop
	echo "Icon=/usr/share/applications/reboot.png" >> /usr/share/applications/reboot.desktop
	echo "Name=Reboot" >> /usr/share/applications/reboot.desktop
	echo "Terminal=false" >> /usr/share/applications/reboot.desktop
	echo "Type=Application" >> /usr/share/applications/reboot.desktop

	cp data/reboot.png /usr/share/applications

	#
	# Icons - Shutdown
	#

	echo "[Desktop Entry]" > /usr/share/applications/shutdown.desktop
	echo "Exec=systemctl poweroff -i" >> /usr/share/applications/shutdown.desktop
	echo "Icon=/usr/share/applications/shutdown.png" >> /usr/share/applications/shutdown.desktop
	echo "Name=Shutdown" >> /usr/share/applications/shutdown.desktop
	echo "Terminal=false" >> /usr/share/applications/shutdown.desktop
	echo "Type=Application" >> /usr/share/applications/shutdown.desktop

	cp data/shutdown.png /usr/share/applications

	#
	# Mouse
	#

	#
	# https://forum.slitaz.org/topic/disable-openbox-menu
	#

	sed -i "s@<action name=\"ShowMenu\"><menu>client-list-combined-menu</menu></action>@@" /home/me/.config/openbox/rc.xml
	sed -i "s@<action name=\"ShowMenu\"><menu>root-menu</menu></action>@@" /home/me/.config/openbox/rc.xml

	#
	# Window Decorations
	#

	local openboxRCWindowDecorations=$(cat data/openbox_rc_window_decorations.xml | tr '\n' ';' | sed 's/;/\\n/g')

	sed -i "s@</openbox_config>@${openboxRCWindowDecorations}\n</openbox_config>@" /home/me/.config/openbox/rc.xml

	#
	# Disable LXPanel
	#

	chmod g-x /bin/lxpanel
	chmod o-x /bin/lxpanel

	chmod g-x /bin/lxpanelctl
	chmod o-x /bin/lxpanelctl
}

function customize_pwquality {
	restore_from_original /etc/security/pwquality.conf

	echo "lcredit=-1" >> /etc/security/pwquality.conf
	echo "minlen=12" >> /etc/security/pwquality.conf
	echo "ucredit=-1" >> /etc/security/pwquality.conf
}

function customize_screensaver {

	#
	# https://ubuntuforums.org/showthread.php?t=1283057
	# http://www.shallowsky.com/linux/x-screen-blanking.html
	#

	echo "xset -dpms" > xset_screensaver
	echo "xset s 300" >> xset_screensaver

	chmod a+x xset_screensaver

	#./xset_screensaver

	mv xset_screensaver /usr/local/bin
}

function customize_shutdown {
	echo "ALL ALL=NOPASSWD: /sbin/shutdown" > /etc/sudoers.d/shutdown
}

function customize_ssh {
	run_as_me echo "Host *" > /home/me/.ssh/config
	run_as_me echo -e "\tIdentityAgent /home/me/.1password/agent.sock" >> /home/me/.ssh/config

	chmod 600 /home/me/.ssh/config

	chown me:me /home/me/.ssh/config
}

function customize_sysctl {

	#
	# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/tuning_and_optimizing_red_hat_enterprise_linux_for_oracle_9i_and_10g_databases/sect-oracle_9i_and_10g_tuning_guide-large_memory_optimization_big_pages_and_huge_pages-configuring_huge_pages_in_red_hat_enterprise_linux_4_or_5
	#

	restore_from_original /etc/sysctl.conf

	#echo "vm.nr_hugepages=8192" >> /etc/sysctl.conf
	echo "vm.max_map_count=262144" > /etc/sysctl.d/docker-elasticsearch.conf

	sysctl -p
}

function customize_systemd_udev_settle {

	#
	# https://bodhi.fedoraproject.org/updates/FEDORA-2020-2faf839786
	# https://bugzilla.redhat.com/show_bug.cgi?id=1854099
	# https://bugzilla.redhat.com/show_bug.cgi?id=1971148
	# https://www.reddit.com/r/Ubuntu/comments/ilf0zg/slow_booting_systemdudevsettleservice
	#

	systemctl mask systemd-udev-settle
}

function customize_xinput {
	chmod 775 data/xinput_logitech_mouse

	cp data/xinput_logitech_mouse /usr/local/bin

	chmod 775 data/xinput_touchpad

	cp data/xinput_touchpad /usr/local/bin

	#if [ -n "$(DISPLAY=:0.0 xinput --list | grep Chicony)" ]
	#then
		localectl set-keymap us
		localectl set-x11-keymap us
	#else
	#	localectl set-keymap us
	#	localectl --no-convert set-x11-keymap br
	#fi

	echo "ALL ALL=NOPASSWD: /bin/localectl" > /etc/sudoers.d/localectl
}

function customize_xrandr {
	chmod 775 data/xrandr_monitor

	cp data/xrandr_monitor /usr/local/bin

	chmod u+x /usr/local/bin/xrandr_monitor

	echo "ALL ALL=NOPASSWD: /usr/local/bin/xrandr_monitor" > /etc/sudoers.d/xrandr_monitor

	echo "ACTION==\"change\", RUN+=\"/bin/sudo /usr/local/bin/xrandr_monitor\", SUBSYSTEM==\"drm\"" > /etc/udev/rules.d/xrandrmonitor.rules

	udevadm control --reload

	chmod g-x /bin/lxrandr
	chmod o-x /bin/lxrandr

	rm -fr /usr/share/applications/lxrandr.desktop

	chmod g-x /bin/xrandr
	chmod o-x /bin/xrandr
}

function customize_vi {
	restore_from_original /etc/virc

	echo "set nofixeol" >> /etc/virc
	echo "set tabstop=4" >> /etc/virc
}

function disable_firewall {

	#
	# https://serverfault.com/questions/429991/how-to-solve-nt-status-host-unreachable-in-centos-when-connecting-to-windows-f
	#

	systemctl stop firewalld

	systemctl disable firewalld
}

function disable_selinux {

	#
	# https://serverfault.com/questions/579720/smbclient-directory-listing-gives-nt-status-access-denied/834160#834160
	# https://unix.stackexchange.com/questions/439712/samba-share-between-fedora-machines
	# https://www.cyberciti.biz/faq/disable-selinux-on-centos-7-rhel-7-fedora-linux
	#

	restore_from_original /etc/selinux/config

	sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
}

function install_autokey {
	dnf_install autokey-gtk gtksourceview3

	rm -fr /home/me/.config/autokey

	run_as_me mkdir -p /home/me/.config/autokey

	cp -R data/autokey /home/me/.config

	mkdir -p /home/me/.config/autostart

	mv /home/me/.config/autokey/autokey.desktop /home/me/.config/autostart

	cp data/start_minimized.py /usr/local/bin

	#
	# https://askubuntu.com/questions/269574/wmctrl-focus-most-recent-window-of-an-app
	#

	cp data/wmctrl_focus_on_app /usr/local/bin
}

function install_bluetooth {

	#
	# https://www.maketecheasier.com/setup-bluetooth-in-linux
	#

	dnf_install blueman

	systemctl enable bluetooth.service

	systemctl start bluetooth.service
}

function install_conky {
	dnf_install conky

	#
	# https://askubuntu.com/questions/181663/how-to-get-conky-to-stay-on-the-desktop
	# https://bbs.archlinux.org/viewtopic.php?id=198630
	# https://unix.stackexchange.com/questions/43347/whats-the-right-way-to-display-system-sound-volume-in-conky
	# https://unix.stackexchange.com/questions/89571/how-to-get-volume-level-from-the-command-line
	#

	cp data/.conkyrc /home/me/.conkyrc
}

function install_dnf_automatic {
	dnf_install dnf-automatic

	sed -i "s@apply_updates = no@apply_updates = yes@" /etc/dnf/automatic.conf

	systemctl enable --now dnf-automatic.timer
}

function install_exfat {
	dnf_install fuse-exfat
}

function install_fonts {

	#
	# https://fedoramagazine.org/5-great-monospaced-fonts-for-coding-and-the-terminal-in-fedora
	#

	dnf_install adobe-source-code-pro-fonts bitstream-vera-sans-fonts dejavu-sans-mono-fonts levien-inconsolata-fonts mozilla-fira-mono-fonts

	#
	# http://www.makeuseof.com/tag/how-to-get-mac-and-windows-fonts-in-ubuntu-linux
	#

	#
	# Mac
	#

	rm -fr /usr/share/fonts/mac

	mkdir -p /usr/share/fonts/mac

	download http://mirrors/dl.dropbox.com/u/26209128/mac_fonts.tar.gz

	tar fxz data/mac_fonts.tar.gz -C /usr/share/fonts/mac --strip=1

	#
	# Windows
	#

	dnf_install mscore-fonts

	#
	# Cache
	#

	#fc-cache -f
}

function install_rpm_fusion {
	rpm_install rpmfusion-free-release http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
	rpm_install rpmfusion-nonfree-release http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

function install_slock {
	dnf_install slock

	#
	# https://archived.forum.manjaro.org/t/writing-systemd-service-units/60350/40
	# https://forum.archlabslinux.com/t/how-to-lock-and-suspend-when-lid-closed/2065/30
	#

	cp data/slock.service /etc/systemd/system

	systemctl enable slock.service
	#systemctl start slock.service
}

function install_terminator {
	dnf_install terminator

	#
	# http://manpages.ubuntu.com/manpages/zesty/en/man5/terminator_config.5.html
	#

	run_as_me mkdir -p /home/me/.config/terminator

	run_as_me cp data/terminator_config /home/me/.config/terminator/config
}

function install_thunar {
	dnf_install gnome-search-tool nautilus Thunar

	rm -f /usr/share/applications/Thunar-bulk-rename.desktop
	rm -f /usr/share/applications/Thunar-folder-handler.desktop
	rm -f /usr/share/applications/thunar-settings.desktop

	rm -fr /home/me/.config/Thunar

	run_as_me mkdir -p /home/me/.config/Thunar

	run_as_me cp data/thunar_uca.xml /home/me/.config/Thunar/uca.xml

	rm -fr /home/me/.config/xfce4

	run_as_me mkdir -p /home/me/.config/xfce4/xfconf/xfce-perchannel-xml

	run_as_me cp data/thunar.xml /home/me/.config/xfce4/xfconf/xfce-perchannel-xml

	#
	# Reboot to reload Thunar's settings.
	#

}

function install_ulauncher {
	dnf_install ulauncher

	run_as_me mkdir -p /home/me/.config/autostart

	cp data/ulauncher/ulauncher.desktop /home/me/.config/autostart

	rm -fr /home/me/.config/ulauncher

	run_as_me mkdir -p /home/me/.config/ulauncher

	cp data/ulauncher/settings.json /home/me/.config/ulauncher
}

function random_digit {

	#
	# https://www.howtogeek.com/devops/how-to-generate-better-random-numbers-at-the-bash-command-line
	#

	echo $(date +%N | cut -b9-9)
}

function random_letter {

	#
	# https://gist.github.com/earthgecko/3089509
	#

	echo $(cat /dev/urandom | tr -cd 'a-z' | fold -w 32 | head -c 1)
}

function remove_unused_icons {
	rm -f /usr/share/applications/fedora-release-notes.webapp.desktop
}

function swap_caps_and_control {

	#
	# http://sapiengames.com/2014/04/08/swap-control-capslock-keys-linux-openbox
	#

	echo "remove Lock = Caps_Lock" > /home/me/.Xmodmap
	echo "remove Control = Control_L" >> /home/me/.Xmodmap
	echo "keysym Control_L = Caps_Lock" >> /home/me/.Xmodmap
	echo "keysym Caps_Lock = Control_L" >> /home/me/.Xmodmap
	echo "add Lock = Caps_Lock" >> /home/me/.Xmodmap
	echo "add Control = Control_L" >> /home/me/.Xmodmap

	#xmodmap /home/me/.Xmodmap

	chmod 700 /usr/bin/setxkbmap
	chmod 700 /usr/bin/xmodmap

	#
	# https://askubuntu.com/questions/29603/how-do-i-clear-xmodmap-settings
	# https://unix.stackexchange.com/questions/98849/how-can-i-write-a-idempotent-xmodmap
	#

	echo "export DISPLAY=:0" > /usr/local/bin/swap_caps_and_control
	echo "export XAUTHORITY=/home/me/.Xauthority" >> /usr/local/bin/swap_caps_and_control
	echo "" >> /usr/local/bin/swap_caps_and_control
	echo "/usr/bin/setxkbmap && /usr/bin/xmodmap /home/me/.Xmodmap" >> /usr/local/bin/swap_caps_and_control

	chmod u+x /usr/local/bin/swap_caps_and_control

	echo "ALL ALL=NOPASSWD: /usr/local/bin/swap_caps_and_control" > /etc/sudoers.d/swap_caps_and_control

	#
	# https://unix.stackexchange.com/questions/14854/xrandr-command-not-executed-within-shell-command-called-from-udev-rule
	# https://www.thegeekdiary.com/how-to-run-a-script-when-usb-devices-is-attached-or-removed-using-udev
	#

	echo "ACTION==\"bind\", RUN+=\"/bin/sudo /usr/local/bin/swap_caps_and_control\", SUBSYSTEM==\"usb\"" > /etc/udev/rules.d/swapcapsandcontrol.rules

	udevadm control --reload
}

function update_packages {
	dnf_erase \
		abiword \
		asunder \
		gigolo \
		gnomebaker \
		gnumeric \
		leafpad \
		lxmusic \
		lxterminal \
		midori \
		pidgin \
		pcmanfm \
		osmo \
		sylpheed \
		xpad

	rm -fr /home/me/.config/libfm
	rm -fr /home/me/.config/pcmanfm

	dnf_install \
		acpi \
		bat \
		exa \
		fd-find \
		ftp \
		fzf \
		genisoimage \
		gh \
		git \
		git-delta \
		git-lfs \
		gitk \
		gnome-disk-utility \
		gparted \
		htop \
		jq \
		livecd-tools \
		lshw \
		maim \
		mmv \
		NetworkManager-vpnc \
		NetworkManager-vpnc-gnome \
		neovim \
		nmap \
		notification-daemon \
		npm \
		ntpstat \
		openvpn \
		p7zip \
		p7zip-plugins \
		patch \
		pavucontrol \
		python2.7 \
		ripgrep \
		s3cmd \
		screen \
		simplescreenrecorder \
		sshpass \
		subversion \
		sysstat \
		telnet \
		tigervnc \
		wget \
		WoeUSB \
		xautolock \
		xbacklight \
		xclip \
		xinput \
		xmodmap \
		xprop \
		xset \
		xsetroot

	sudo dnf update -qy
}

install_rpm_fusion

#
# Run the update_packages function three times. For some reason, some packages
# do not get installed until the second time.
#

for i in {1..3}
do
	echo ""
	echo "Update packages, attempt ${i}."
	echo ""

	update_packages
done

customize_bash
customize_cryptsetup
customize_git
customize_hostname
customize_hosts
customize_lxdm
customize_notifications
customize_openbox
customize_pwquality
customize_screensaver
customize_shutdown
customize_ssh
customize_sysctl
customize_systemd_udev_settle
customize_xinput
customize_xrandr
customize_vi
disable_firewall
disable_selinux
install_autokey
install_bluetooth
install_conky
install_dnf_automatic
install_exfat
install_fonts
install_slock
install_terminator
install_thunar
install_ulauncher
remove_unused_icons
swap_caps_and_control

customize_login