#!/bin/bash
#This script will collect the following: BIOS, CPU count and speed, Memory size, hostname, etc
hostname=`hostname`
kernel=`uname -r`
cpu_model=`cat /proc/cpuinfo |grep 'model name' |cut -f 2 -d ":"|uniq`
cpu_cores=`cat /proc/cpuinfo |grep 'model name' |cut -f 2 -d ":"|wc -l`
os=`cat /etc/SuSE-release |head -1`
os_patchlevel=`cat /etc/SuSE-release |grep PATCHLEVEL |awk '{ print $3 }'`
vendor=`/usr/sbin/dmidecode -s system-manufacturer`
model=`/usr/sbin/dmidecode -s system-product-name`
bios_version=`/usr/sbin/dmidecode -s bios-version`
bios_date=`/usr/sbin/dmidecode -s bios-release-date`
system_serial=`/usr/sbin/dmidecode -s system-serial-number`
memory_total=`cat /proc/meminfo |grep MemTotal|awk '{ print $2 }'`
file_system=`df -P -T -h |grep -v Filesystem|awk '{ print $7 " " $2 " " $3 }'|grep "/"|egrep -v "iso9660|dev"`
zabbix=`/opt/zabbix/bin/zabbix_agentd -V |head -n 1 |awk '{ print $4 }'`
centrify=`adinfo -v |awk '{ print $3 }'|sed "s/)//"`
esm=`cat /esm/version.txt |grep ^ESM|awk -F" " '{print $2}'`
echo "$hostname,$system_serial,$vendor,$model,$cpu_cores,$os,$os_patchlevel,$cpu_model,$memory_total"
