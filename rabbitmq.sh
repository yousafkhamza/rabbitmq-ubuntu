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

ubuntu=$(grep -i "ubuntu" /etc/os-release | wc -l > 2>&1; echo $?)
rabbitmq=$(which rabbitmq-server > 2>&1; echo $?)

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
				echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu" 
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
				echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu"
				exit 1
			fi
			
	# Dependancies installed succesfully
	# Update new repo once maybe you will get error
	sudo apt-get update -y > 2>&1

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
				echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu"
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
				echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu"
				ezit 1
			fi

	# Service status and enable
	status=$(sudo systemctl status rabbitmq-server > 2>&1; echo $?)
		if [[ "status" -eq 0 ]]; then
			echo ""
			echo "RabbitMQ Service enabling............"
			echo ""
			sudo rabbitmq-plugins enable rabbitmq_management
			sleep 1
			echo ""
		else
			echo "" 
			echo "Service enabling failed....... Please check server ports......."
			echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu"
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
			rm -f erlang-solutions_1*.deb
			ip=$(curl ifconfig.io)
			echo ""
			echo "http://$ip:15672/ Please check the same with admin and password."
			sleep 1
		else
			echo "" 
			echo "Admin password setting is failed........."
			echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu"
			exit 1
		fi
	else
		echo ""
		echo "The script is only support with ubuntu 16-20 version so you may please check the manual installation steps"
		echo "Manual installation steps https://github.com/yousafkhamza/rabbitmq-ubuntu"
		exit 1
	fi
fi
