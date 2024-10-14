#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
	echo "Для выполнения требуются права суперпользователя!"
	exit 1
fi
active_status="$(systemctl is-active hello_world.service)"
demon=/etc/systemd/system/hello_world.service
if [ ! -e "$demon" ]; then 
	touch "$demon"
   cat << EOF > "$demon"
[Unit]
Description=adress of eth0
After=network.target

[Service]
ExecStart=/usr/local/bin/hello_world.sh
Restart=always
User=root
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=hello_world
[Install]
WantedBy=multi-user.target
EOF

 sudo systemctl daemon-reload
 sudo systemctl enable hello_world.service
 sudo systemctl start hello_world.service 
 echo "Служба hello_world была запущена"

 if [ "$active_status" != "active" ]; then
	 systemctl start hello_world.service
 fi

fi
########################################################################################################################################################################################
log_file=/etc/adress.log

if [ ! -e "$log_file" ]; then
 touch /etc/adress.log
fi

while true; do
 if ip link show enp2s0 &> /dev/null; then
    ip neigh show dev enp2s0 | awk '{print $1}' >> "$log_file"
    echo "" >> "$log_file"
 else
    echo "Не существует порта enp2s0"
    exit 1
 fi
 sleep 60
done
