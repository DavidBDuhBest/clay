# Networking

## NCMLI

1. What is my IP?

	1. Use Chrome to open https://www.whatismyip.com. If that site is down, try using http://ip4.me, http://ip6.me, http://whatismyv6.com, or https://www.nirsoft.net/show_my_ip_address.php.

	1. This website shows your public IP. Look at your neighbor's computer. Notice that we all share the same public IP. Why? Everyone in this room is connecting to the Internet through the same router.

	1. Launch Terminator.

	1. Type ***nmcli***.

		```
		eno1: connected to Wired connection 1
		        "Intel Ethernet"
		        ethernet (e1000e), 1C:69:7A:0F:D6:BE, hw, mtu 1500
		        ip4 default
		        inet4 192.168.111.222/22
		        route4 0.0.0.0/0
		        route4 192.168.108.0/22
		        inet6 fe80::cd3:b8a:5544:f5ff/64
		        route6 fe80::/64
		        route6 ff00::/8

		wlp0s20f3: connected to Liferay
		        "Intel Wireless-AC 9462"
		        wifi (iwlwifi), C8:09:A8:9C:54:91, hw, mtu 1500
		        inet4 192.168.110.160/22
		        route4 0.0.0.0/0
		        route4 192.168.108.0/22
		        inet6 fe80::677d:4d0a:bdc8:1c23/64
		        route6 fe80::/64
		        route6 ff00::/8
		```

		The command ***nmcli*** also shows a lot of other information you can ignore.

		If your ethernet cable is connected, then ***eno1*** will show an IP. For example, the IP above shows ***192.168.111.222***.

		If your WiFi is connected, then ***wlp0s20f3*** will show an IP. For example, the IP above shows ***192.168.110.160***.

	1. Type ***ifconfig*** to get similar information through another program. Find the same IPs.

1. List available WiFi networks.

	1. Type ***nmcli device wifi list***.

	1. Turn on your phone's hotspot feature.

	1. Type ***nmcli device wifi list***.

	1. If your phone's hotspot network is not available, type ***nmcli device wifi rescan***. Then try again.

1. Connect to your phone's hotspot.

	1. Type ***nmcli device wifi connect \<NETWORK_NAME\> password \<NETWORK_PASSWORD\>***.

	1. Use Chrome to open https://www.whatismyip.com. Notice that your public IP is now different.

	1. Type ***nmcli***. Notice that your private IP is also different.

1. Optionally, see [nmcli](https://fedoraproject.org/wiki/Networking/CLI) for more information.

## Ping

1. What is ping?

	<!--
	https://teamuvdotorg1.files.wordpress.com/2014/08/untitled7.jpg
	-->

	![](images/01.jpg)

1. Ping your own computer.

	1. Launch Terminator.

	1. Type ***ping 127.0.0.1***.

	1. Type ***ping localhost***.

	1. Both ***127.0.0.1*** and ***localhost*** are names for your own computer.

1. Ping your neighbor's computer.

	1. Make sure you and your neighbor are both connected to the Liferay WiFi network.

	1. Type ***ping 192.168.xxx.xxx*** where ***xxx.xxx*** is your neighbor's IP. If it works, you should get a result like this:

		```
		PING 192.168.111.248 (192.168.111.248) 56(84) bytes of data.
		64 bytes from 192.168.111.248: icmp_seq=1 ttl=64 time=43.7 ms
		64 bytes from 192.168.111.248: icmp_seq=2 ttl=64 time=66.4 ms
		64 bytes from 192.168.111.248: icmp_seq=3 ttl=64 time=10.8 ms
		```

	1. Type ***ping 192.168.111.500***. This command fails because ***192.168.111.500*** is not a valid IP.

		```
		ping: 192.168.111.500: Name or service not known
		```

	1. Connect to your phone's network while your neighbor is connected to the Liferay network.

	1. Try pinging your neighbor's IP. This fails because you are behind different routers. Imagine a router as a door to a room. When you are in the same room, you can ping each other and talk to each other. When you are in different rooms, you cannot ping or talk to each other.

	1. Tell your neighbor to join your phone's network. Try pinging your neighbor's IP again. It works because you are both behind the same router.

1. Optionally, see the man page for [ping](https://linux.die.net/man/8/ping) for more information.

## SSH

<!--1. Start the SSH daemon.

	1. Launch Terminator.

	1. Type ***sudo systemctl start sshd.service*** to start the SSH daemon so that other people can SSH into your computer.-->

1. Connect via SSH to a remote computer.

	1. Type ***ssh 192.168.xxx.xxx*** to SSH into your neighbor's computer. You already know the username and password.

	1. Notice that your Bash prompt now looks slightly different. There should be four characters that are different. Find the four characters. This should be a reminder to tell you when you are on your machine and when you are connected to your neighbor's machine. For example, one may be ***me@nuc10-i7-k6d9*** and the other may be ***me@nuc10-i7-z3f5***.

	1. Type ***la***.

	1. Ask your neighbor to type ***echo "\<RANDOM_NUMBER\>" > \<RANDOM_NAME\>.txt*** where ***\<RANDOM_NUMBER\>*** is a random number he makes up and ***\<RANDOM_NAME\>*** is a random name he makes up.

	1. Type ***la***. Find the newly created file.

	1. Type ***more \<RANDOM_NAME\>***. Tell your neighbor the name of the file and the number in the file.

	1. Type ***rm \<RANDOM_NAME\>*** to delete your neighbor's file.

	1. Type ***exit***.

	1. Notice the Bash prompt changed.

	1. Repeat the exercise but have your neighbor log into your computer.

1. Connect via SSH to yourself.

	1. Launch Terminator and create two tabs.

	1. In the first tab, type ***ssh localhost***.

	1. Notice the Bash prompt is the same because you are still on your computer.

	1. Type ***la***.

	1. In the second tab, make a random file.

	1. In the first tab, type ***la***.

	1. In the first tab, type ***exit***. This does not close your tab, because you are just exiting from SSH.

	1. Type ***exit*** again to close the tab.

	1. Delete your random file.

1. Make an SSH key.

	1. Launch Terminator.

	1. Type ***ssh-keygen -t rsa -C "\<YOUR_EMAIL_ADDRESS\>"***.

		1. For the file name, type your full name in lower case without spaces. For our example, suppose the file name is ***joe_bloggs***.

		1. Do not use a passphrase.

	1. Two files were randomly created: ***joe_bloggs*** and ***joe_bloggs.pub***.

		1. Type ***more joe_bloggs***.

		1. Type ***more joe_bloggs.pub***.

	1. The private file is named ***joe_bloggs*** and should NEVER be given to anyone.

	1. The public file is named ***joe_bloggs.pub*** and is safe to give to anyone.

1. Move the SSH key to the right directory.

	1. Type ***mkdir -p ~/.ssh***.

		1. The ***-p*** argument in ***mkdir*** tells the program to make the directory, but if it does not exist, do not complain.

	1. Type ***chmod 700 ~/.ssh*** to change that directory's permission to a value of 700. There is no need to understand what 700 means for now. But it will not work without that permission.

	1. Type ***la ~/.ssh***. There is already a file there named authorized_keys that would normally not exist in a fresh installation but was installed on your computer earlier.

	1. Type ***mv joe_bloggs ~/.ssh/id_rsa***.

	1. Type ***mv joe_bloggs.pub ~/.ssh/id_rsa.pub***.

	1. Type ***la ~/.ssh***

	1. Notice that you renamed ***joe_bloggs*** to ***id_rsa*** and ***joe_bloggs.pub*** to ***id_rsa.pub*** and moved the files to ***~/.ssh***.

1. Connect via an SSH key.

	1. Connect to your neighbor's computer. You will be prompted to login with a username and password like before.

	1. Type ***more ~/.ssh/authorized_keys***.

	1. Notice that there is already a public key there for brian.chan@liferay.com. It printed in more than one line because it is a very long line, but in reality, it is all in just one line.

	1. In a new tab on your computer, type ***osub ~/.ssh/id_rsa.pub***. Copy just the FIRST line.

	1. Go back to the tab where you are logged into your neighbor's computer and type ***echo "\<THE_LONG_LINE\>" > joe_bloggs.pub***.

	1. Ask your neighbor to use Sublime to open ***joe_bloggs.pub*** (that you just made) and ***~/.ssh/authorized_keys***. You may notice that it is difficult (or impossible) to open ***~/.ssh/authorized_keys*** from the GUI.

	1. Ask your neighbor to copy the line in ***joe_bloggs.pub*** into ***~/.ssh/authorized_keys*** so that each key is in its own line. Ask him to save the file.

	1. The first line is a key for brian.chan@liferay.com. The second line is the value from ***joe_bloggs.pub***. The two lines should look similar, but with different random values.

	1. Go back to the tab where you are logged into neighbor's computer and type ***chmod 640 ~/.ssh/authorized_keys*** to ensure the right permissions. Type ***more ~/.ssh/authorized_keys*** to verify it contains the new key.

	1. Open a new Terminator tab and SSH into your neighbor's computer. Notice that you no longer have to type in a username or password.

	1. Type ***exit*** to log out of your neighbor's computer. Keep this tab to quickly test logging in and out of your neighbor's computer.

	1. On your computer, type ***mv ~/.ssh/id_rsa ~/.ssh/bad_name***.

	1. Try logging into your neighbor's computer. You are prompted for a username and password.

	1. On your computer, type ***mv ~/.ssh/bad_name ~/.ssh/id_rsa***.

	1. Try logging into your neighbor's computer. You are automatically logged in.

	1. By adding a public key in ***~/.ssh/authorized_keys***, you are telling SSH that anyone with the corresponding private key can access your computer.

1. Optionally, see the man page for [ssh](https://linux.die.net/man/1/ssh) for more information.

## SFTP

1. SFTP to your neighbor's computer with and without an SSH key.

	1. Type ***sftp 192.168.xxx.xxx*** to SFTP into your neighbor's computer. You are automatically logged in.

	1. Type **exit** to log out of your neighbor's computer.

	1. On your computer, type ***mv ~/.ssh/id_rsa ~/.ssh/bad_name***.

	1. Type ***sftp 192.168.xxx.xxx*** to SFTP into your neighbor's computer. You are prompted for a username and password.

	1. On your computer, type ***mv ~/.ssh/bad_name ~/.ssh/id_rsa***.

1.	Upload, download, and delete files.

	1. Make some random files on your machine.

	1. Type ***la***.

	1. SFTP to your neighbor's computer.

	1. Type ***ls***.

	1. Type ***put \<RANDOM_FILE_1\>*** to upload one of your files.

	1. Type ***ls***.

	1. Ask your neighbor to make some random files on his machine.

	1. Type ***ls***.

	1. Type ***get \<RANDOM_FILE_2\>*** to download one of your neighbor's files.

	1. Type ***rm \<RANDOM_FILE_2\>*** to delete one of your neighbor's files.

	1. Type ***exit*** to log out of SFTP.

	1. Type ***la*** to verify that you downloaded your neighbor's file.

1. Optionally, see the man page for [sftp](https://linux.die.net/man/1/sftp) for more information.

## Rsync

1. Rsync files from your computer to your neighbor's computer.

	1. rsync -av ***/home/me/\<RANDOM_FILE_1\> me@192.168.xxx.xxx:/home/me***

1. Rsync files from your neighbor's computer to your computer.

	1. rsync -av ***me@192.168.xxx.xxx:/home/me/\<RANDOM_FILE_2\> /home/me***

1. Repeat the above two exercises by syncing over a directory with many directories and files.

1. Repeat one of the above exercises by hiding ***~/.ssh/id_rsa*** to show that you will now be prompted for a username and password.

## Ports

1. Your computer has an IP and listens on many ports. Ports are numbers between 0 and 65535. Two programs on the same machine cannot listen on the same port.

	1. SSH defaults to run on port 22.

	1. Apache defaults to run port 80.

1. Telnet to localhost on port 22.

	1. Type ***telnet localhost 22***.

		```
		$ telnet localhost 22
		Trying ::1...
		Connected to localhost.
		Escape character is '^]'.
		SSH-2.0-OpenSSH_8.4
		```

	1. The reply shows that SSH is running on port 22.

	1. Type ***<CONTROL+]>*** and then type ***quit*** to exit out of telnet on port 22.

1. Telnet to localhost port 23.

	1. Type ***telnet localhost 23***. This command fails because nothing is running on port 23.

1. Telnet to your neighbor's computer.

	1. Type ***telnet 192.168.xxx.xxx 22***.

	1. Type ***<CONTROL+]>*** and then type ***quit*** to exit out of telnet on port 22.

	1. Ask your neighbor to turn off his WiFi by typing ***nmcli radio wifi off***.

	1. Type ***telnet 192.168.xxx.xxx 22***. This fails because your neighbor's computer is not connected to the network.

	1. Ask your neighbor to turn on his WiFi by typing ***nmcli radio wifi on***.

	1. Type ***telnet 192.168.xxx.xxx 22***. This works because your neighbor's computer is connected to the network.

1. Telnet is a quick way to verify if you can communicate with another computer on a specific port.

1. Optionally, see the man page for [telnet](https://linux.die.net/man/1/telnet) and this [tutorial](http://www.linuxandubuntu.com/home/what-are-ports-how-to-find-open-ports-in-linux) for more information.

<!--## Systemctl

1. Type ***systemctl status sshd.service***.

1. Type ***sudo systemctl stop sshd.service*** to stop the SSH daemon.

1. Type ***systemctl status sshd.service***.

1. Type ***telnet localhost 22***. Why did this command fail?

1. Type ***sudo systemctl start sshd.service***.

1. Type ***systemctl status sshd.service***.

1. Type ***telnet localhost 22***. Why did this command succeed?

1. Type ***sudo systemctl disable sshd.service***.

1. Type ***systemctl status sshd.service***.

1. Restart your computer. After logging back in, type ***telnet localhost 22***. Why did this command fail?

1. Type ***sudo systemctl enable sshd.service***.

1. Type ***systemctl status sshd.service***.

1. Restart your computer. After logging back in, type ***telnet localhost 22***. Why did this command succeed?

1. Optionally, see this [tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units) for more information.-->