#!/bin/bash

host=$1
dev=$2
domain=$3
gateway=`host $host |cut -f 4 -d " "|awk -F. '{ print $1 "." $2 "." $3 ".1" }'`
ip=`host $host|awk '{ print $4 }'`
mac=`ifconfig $dev |grep HW|awk '{ print $5 }'| tr "[:upper:]" "[:lower:]"`
default=`host $host |cut -f 4 -d " "|awk -F. '{ print $1 "." $2 "." $3 ".1" }'`
id=`ethtool -i eth2 |grep bus |awk '{ print $2 }'|awk -F: '{ print $2":"$3 }'`
name=`lspci | grep $id |awk -F: '{ print $3 }'| sed "s/^ //"`
echo "You are setting the IP to $ip, the hostname to $host, configuring device $dev, domain $domain, name to $name and setting the default route to $default"
sed -i "s/BOOTPROTO.*/BOOTPROTO='static'/" /etc/sysconfig/network/ifcfg-eth-id-$mac
sed -i "s/^IPADDR.*.$/IPADDR='$ip'/" /etc/sysconfig/network/ifcfg-eth-id-$mac
sed -i "s/NAME.*/NAME='$name'/" /etc/sysconfig/network/ifcfg-eth-id-$mac
echo "default $default - -">/etc/sysconfig/network/routes
echo "$host.$domain">/etc/HOSTNAME
echo "$ip $host.$domain $host">>/etc/hosts

