#!/bin/bash
rpm -vih http://repo.zabbix.com/zabbix/3.0/rhel/6/x86_64/zabbix-agent-3.0.4-1.el6.x86_64.rpm
hostname=`hostname`
ip=`ifconfig | awk 'NR==2 {split($2,ip,":");print ip[2]}'`
sed -i "s/Hostname=Zabbix server/Hostname=$hostname/"  /etc/zabbix/zabbix_agentd.conf
if [[ $? -eq 0 ]]; then
    echo "change the hostname on config file success!"
else
    echo "change the hostname on config file failed"
fi
sed -i "s/ServerActive=127.0.0.1/ServerActive=192.168.6.120/"    /etc/zabbix/zabbix_agentd.conf
if [[ $? -eq 0 ]]; then
    echo "change the ServerActive on config file success!"
else
    echo "change the ServerActive on config file failed"
fi
sed -i "s/Server=127.0.0.1/Server=192.168.6.120/"    /etc/zabbix/zabbix_agentd.conf
if [[ $? -eq 0 ]]; then
    echo "change the Server on config file success!"
else
    echo "change the Server on config file failed"
fi
/etc/init.d/zabbix-agent start
if [[ $? -eq 0 ]]; then
    echo "start zabbix-agent success!"
else
    echo "start zabbix-agent failed!"
fi

#echo 'UserParameter=common_service_status[*],/etc/zabbix/shells/common_service_status.sh "$1" ' >> /etc/zabbix/zabbix_agentd.d/zabbix_linux_plugin.conf

