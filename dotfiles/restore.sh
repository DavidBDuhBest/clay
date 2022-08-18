#!/bin/bash

source /home/me/dev/projects/liferay-basic-training/dotfiles/_common.sh

PACKAGE_NAMES=(
	os
	#
	java
	#
	1password
	brave
	chrome
	docker
	idea
	figma
	firefox
	javascript
	#kvm
	libreoffice
	msteams
	mysql
	openvpn
	skype
	slack
	smartgit
	sublime
	virtualbox
	vlc
	vscode
	zoom
	#
	sentinelone
)

for PACKAGE_NAME in ${PACKAGE_NAMES[@]}
do
	echo ""
	echo "Restoring ${PACKAGE_NAME}."
	echo ""

	cd /home/me/dev/projects/liferay-basic-training/dotfiles/${PACKAGE_NAME}

	./restore.sh

	echo ""
	echo "Restored ${PACKAGE_NAME}."
	echo ""
done

rm -f /home/me/.bash_history
rm -f /root/.bash_history

#sudo shutdown -r now