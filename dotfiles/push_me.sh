#!/bin/bash

PUSH_ME_SSH_FLAGS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q"

function authorize_ssh {
	echo "Authorizing ${1}@${2}."

	sshpass -p madeofdust ssh ${PUSH_ME_SSH_FLAGS} ${1}@${2} 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo "TODOKEYHERE" > ~/.ssh/authorized_keys && chmod 640 ~/.ssh/authorized_keys && mkdir -p /home/me/dev/projects'

	local sshpass_exit_code=$?

	if [ ${sshpass_exit_code} -gt 0 ]
	then
		echo "Unable to connect to ${1}@${2}."

		exit
	fi

	if [ ${1} == "root" ]
	then
		local random_password=$(echo ${RANDOM} | md5sum | head -c 30)

		#echo ${random_password}

		bash -c "sshpass -p madeofdust ssh ${PUSH_ME_SSH_FLAGS} ${1}@${2} 'echo \"root:${random_password}\" | chpasswd'"
	fi
}

function fix_git_configs {
	ssh ${PUSH_ME_SSH_FLAGS} me@${1} "sed -i '/work-dir = \/home\/brian\/dev\/work\/github\/liferay-portal/d' /home/me/dev/projects/liferay-portal/.git/config"
	ssh ${PUSH_ME_SSH_FLAGS} me@${1} "sed -i '/work-dir = \/home\/me\/dev\/work\/github\/liferay-portal/d' /home/me/dev/projects/liferay-portal/.git/config"

	ssh ${PUSH_ME_SSH_FLAGS} me@${1} sed -i s@/github/@/@g /home/me/dev/projects/liferay-portal-ee/.git/config
	ssh ${PUSH_ME_SSH_FLAGS} me@${1} sed -i s@/home/brian@/home/me@g /home/me/dev/projects/liferay-portal-ee/.git/config
}

function main {
	for ip in ${@}
	do
		authorize_ssh me ${ip}
		authorize_ssh root ${ip}
	done

	for ip in ${@}
	do
		echo ""
		ssh ${PUSH_ME_SSH_FLAGS} me@${ip} echo "\$HOSTNAME"
		echo ""

		sync_repository ${ip} git-tools
		sync_repository ${ip} liferay-basic-training
		sync_repository ${ip} liferay-learn
		sync_repository ${ip} liferay-portal
		sync_repository ${ip} liferay-portal-ee

		ssh ${PUSH_ME_SSH_FLAGS} root@${ip} /home/me/dev/projects/liferay-basic-training/dotfiles/restore.sh

		fix_git_configs ${ip}

		ssh ${PUSH_ME_SSH_FLAGS} me@${ip} /home/me/dev/projects/prepare_repositories
	done
}

function sync_repository {
	echo "Syncing ${2}."

	rsync -a -e "ssh ${PUSH_ME_SSH_FLAGS}" --delete --exclude *.brian.* /home/brian/dev/projects/github/${2} me@${1}:/home/me/dev/projects
}

main "${@}"