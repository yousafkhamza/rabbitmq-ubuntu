Manual Installation steps RabbitMQ on Ubuntu
==================================================

Install Erlang
--------------------------------------------------
```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update -y
sudo apt-get install -y erlang erlang-nox
```

Add RabbitMQ apt repository
--------------------------------------------------
```
echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
```

Update the package list
--------------------------------------------------
```
sudo apt-get update -y
```

Install RabbitMQ
--------------------------------------------------
```
sudo apt-get install -y rabbitmq-server
```

Start RabbitMQ
--------------------------------------------------
```
sudo systemctl start rabbitmq-server
```

Check RabbitMQ status
--------------------------------------------------
```
sudo systemctl status rabbitmq-server
```

Enable RabbitMQ service so it starts on boot
--------------------------------------------------
```
sudo systemctl enable rabbitmq-server
```

Setup RabbitMQ Web Management Console
--------------------------------------------------
```
sudo rabbitmq-plugins enable rabbitmq_management
```

Single RabbitMQ Instances
--------------------------------------------------
Create Admin User in RabbitMQ
```
sudo rabbitmqctl add_user admin password 
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
```

Clustered RabbitMQ Instances
--------------------------------------------------
Setup Cluster On The Master Node
```
wget https://gist.githubusercontent.com/fernandoaleman/05cbf15e0e58f8de7a29a21b24f9debb/raw/55efa7b36c245a9f6ffa3bcd2382c078cce0e9a2/rabbitmq-cluster.sh
chmod +x rabbitmq-cluster.sh
./rabbitmq-cluster.sh
```

Enable SSL
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
