# RabbitMQ Installation on Ubuntu
[![Build](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

---
## Description
_What is RabbitMQ:_ RabbitMQ is an open-source message-broker software that originally implemented the Advanced Message Queuing Protocol and has since been extended with a plug-in architecture to support Streaming Text Oriented Messaging Protocol, MQ Telemetry Transport, and other protocols

----
## Feature
- Easy to install rabbitmq server on ubuntu
- Completely automated with a bash script
- All the dependencies are installed with the script and also included service enabling and starts on the servers
- Please find the below manual installation steps are provided

----
## Pre-Requests
- Only supports ubuntu and Debian based OS
- Basic knowledge of rabbitMQ Server

```
sudo apt install git -y
```

----
## How to Get
```

git clone https://github.com/yousafkhamza/rabbitmq-ubuntu.git
cd rabbitmq-ubuntu
chmod +x rabbitmq.sh
```

### Script running be like
```
ubuntu@ip-172-31-33-229:~$ ./rabbitmq.sh
# ------------------or---------------------- #
ubuntu@ip-172-31-33-229:~$ bash rabbitmq.sh
```

----
## Output be like

_Installation_
![alt_txt](https://i.ibb.co/1MDyDc6/Screenshot-54.png)

_Already installed_
![alt_txt](https://i.ibb.co/pxrbGgX/Screenshot-55.png)




----
## Behind the Code

```
#!/bin/bash

printf "\e[1;92m                   ____       _     _     _ _   __  __  ___     \e[0m\n"
printf "\e[1;92m                  |  _ \ __ _| |__ | |__ (_) |_|  \/  |/ _ \	\e[0m\n"
printf "\e[1;92m                  | |_) / _' | '_ \| '_ \| | __| |\/| | | | |	\e[0m\n"
printf "\e[1;92m                  |  _ < (_| | |_) | |_) | | |_| |  | | |_| |	\e[0m\n"
printf "\e[1;92m                  |_| \_\__,_|_.__/|_.__/|_|\__|_|  |_|\__\_\	\e[0m\n"
printf "\n"
printf "\e[1;77m\e[45m   RabbitMQ Installation Script for ubuntu Author: @yousafkhamza (Github|LinkedIn|Instagram)     \e[0m\n"
printf "\n"
sleep 1

ubuntu=$(grep -i "ubuntu" /etc/os-release | wc -l > 2&>1; echo $?)
rabbitmq=$(which rabbitmq-server > 2&>1; echo $?)

if [[ "$rabbitmq" -eq 0 ]]; then
	echo "RabbitMQ is already installed on the server so please remove the same manually......."
	exit 1
else
	# Installation started..........
	echo "RabbitMQ installation is started..........."
	sleep 1

	if [ -f /etc/os-release ] && [[ "$ubuntu" -eq 0 ]]; then
		echo ""
		echo "Dependency ERLANG installation started........."
		echo "If you're exited the script once you enter any values please retry the script once"
		echo ""
		sleep 1
		wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
		sudo dpkg -i erlang-solutions_1.0_all.deb 
			if [ $? -eq 0 ]; then
				echo ""
				echo "Dependancies installtion started and it take 5-10 minutes and it depends on your internet........"
				sleep 1
				sudo apt-get update -y
				sudo apt-get install -y erlang erlang-nox
				echo ""
			else
				echo ""
				echo "Your dependecy installation is failed so please go through the GitHub and iinstall the same as manual"
				echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu/tree/main" 
				exit 1
			fi
		echo "RabbitMQ Repository adding to the repos........."
		echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
		wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
			if [ $? -eq 0 ]; then
				echo ""
				echo "Repository adding successsfully.........."
				sleep 1
				echo ""
			else
				echo "" 
				echo "Repository adding failed......."
				echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu/tree/main"
				exit 1
			fi
			
	# Dependancies installed succesfully
	# Update new repo once maybe you will get error
	sudo apt-get update -y > 2&>1

	# RabbitMQ Installation from the added repository
	sudo apt-get install -y rabbitmq-server
			if [ $? -eq 0 ]; then
				echo ""
				echo "RabbitMQ Installation successfull we are going to start and enable the services"
				sleep 1
				echo ""
			else
				echo "" 
				echo "RabbitMQ installtion failed......."
				echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu/tree/main"
				exit 1
			fi
			
	# Service start section
	sudo systemctl start rabbitmq-server
			if [ $? -eq 0 ]; then
				echo ""
				echo "RabbitMQ services started successfully"
				sleep 1
				echo ""
			else
				echo "" 
				echo "Service starting failed....... Please check server ports......."
				echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu/tree/main"
				ezit 1
			fi

	# Service status and enable
	status=$(sudo systemctl status rabbitmq-server > 2&>1; echo $?)
		if [[ "status" -eq 0 ]]; then
			echo ""
			echo " RabbitMQ Service enabling............"
			echo ""
			sudo rabbitmq-plugins enable rabbitmq_management
			sleep 1
			echo ""
		else
			echo "" 
			echo "Service enabling failed....... Please check server ports......."
			echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu/tree/main"
			exit 1
		fi
		
	# RabbitMQ User and password setting
	sudo rabbitmqctl add_user admin password 
		if [[ $? -eq 0 ]]; then
			echo ""
			echo "Global password is setting for your RabbitMQ GUI............"
			echo "Global Username is 'admin', Password is 'password'"
			echo "After setup please reset with a tough password......."
			echo ""
			sleep 1
			sudo rabbitmqctl set_user_tags admin administrator
			sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
			echo ""
			echo "Installation is successfull. Please login to your RabbitMQ GUI......"
			echo "Please use the below URL or check with net-tools like netstat netstat -ntlp"
			ip=$(curl ifconfig.io)
			echo ""
			echo "http://$ip:15672/ Please check the same with admin and password."
			sleep 1
		else
			echo "" 
			echo "Admin password setting is failed........."
			echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu/tree/main"
			exit 1
		fi
	else
		echo ""
		echo "The script is only support with ubuntu 16-20 version so you may please check the manual installation steps"
		echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu/tree/main"
		exit 1
	fi
fi
```

----
## Manual Installation steps RabbitMQ on Ubuntu
==================================================

### Install Erlang
--------------------------------------------------
```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update -y
sudo apt-get install -y erlang erlang-nox
```

### Add RabbitMQ apt repository
--------------------------------------------------
```
echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
```

### Update the package list
--------------------------------------------------
```
sudo apt-get update -y
```

### Install RabbitMQ
--------------------------------------------------
```
sudo apt-get install -y rabbitmq-server
```

### Start RabbitMQ
--------------------------------------------------
```
sudo systemctl start rabbitmq-server
```

### Check RabbitMQ status
--------------------------------------------------
```
sudo systemctl status rabbitmq-server
```

### Enable RabbitMQ service so it starts on boot
--------------------------------------------------
```
sudo systemctl enable rabbitmq-server
```

### Setup RabbitMQ Web Management Console
--------------------------------------------------
```
sudo rabbitmq-plugins enable rabbitmq_management
```

### Single RabbitMQ Instances
--------------------------------------------------
Create Admin User in RabbitMQ
```
sudo rabbitmqctl add_user admin password 
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
``` 

----
### Enable SSL (_Optionel this not included on the script_)
--------------------------------------------------
Enable RabbitMQ and Management SSL
```
[
 {rabbit, [
 {ssl_listeners, [5671]},
 {ssl_options, [{cacertfile,"/path/to/cacertfile"},
 {certfile,"/path/to/certfile"},
 {keyfile,"/path/to/keyfile"},
 {verify,verify_peer},
 {fail_if_no_peer_cert,true}]}
 ]},
 {rabbitmq_management, [
 {listener, [{port, 15671},
 {ssl, true},
 {ssl_opts, [{cacertfile, "/path/to/cacertfile"},
             {certfile,   "/path/to/certfile"},
             {keyfile,    "/path/to/keyfile"}]}
            ]
 }
 ]}
].
```

----
## Reference
_Reference URL's_ 
- https://www.rabbitmq.com/install-debian.html
- https://www.rabbitmq.com/download.html
- https://youtu.be/eazz-Je4HAA
- https://www.digitalocean.com/community/tutorials/how-to-install-and-manage-rabbitmq

## Conclusion
It's a simple bash script used for the installation of rabbitmq and it's completely automated with a bash script.

### ⚙️ Connect with Me 

<p align="center">
<a href="mailto:yousaf.k.hamza@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white"/></a>
<a href="https://www.linkedin.com/in/yousafkhamza"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"/></a> 
<a href="https://www.instagram.com/yousafkhamza"><img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white"/></a>
<a href="https://wa.me/%2B917736720639?text=This%20message%20from%20GitHub."><img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white"/></a><br />
