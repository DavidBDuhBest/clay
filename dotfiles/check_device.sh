#!/bin/bash

function test_luks_passphrase {
	local default_luks_passphrase='madeofdust'
	local default_luks_device="$(lsblk -lo PATH,FSTYPE | grep crypto_LUKS | awk '{print $1}')"

	if printf "${default_luks_passphrase}" | sudo cryptsetup luksOpen --test-passphrase ${default_luks_device}
	then
		notify-send -t 0 -u critical "Security Compliance" "Change the default hard drive encryption password with the command:\n\n<b>sudo cryptsetup luksChangeKey ${default_luks_device}</b>"
	fi
}

function test_user_password {
	local default_user_password="madeofdust"

	if printf "${default_user_password}" | su - me -c "echo" > /dev/null 2>&1
	then
		notify-send -t 0 -u critical "Security Compliance" "Change the default user password with the command:\n\n<b>passwd</b>"
	fi
}

function main {
	test_luks_passphrase
	test_user_password
}

main