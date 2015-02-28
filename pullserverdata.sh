hostname -f
ethtool eth2
ethtool eth3
echo ADINFO
adinfo
echo IFCONFIG
ifconfig | egrep -w 'HWaddr|addr|Mask'
echo ROUTE 
route -n
df -h
echo NAMESERVER
egrep -w 'search|nameserver' /etc/resolv.conf
echo NTP
egrep -w 'server' /etc/ntp.conf
echo SNMP
egrep -w 'syslocation|syscontact|rocommunity|trapsink' /etc/snmp/snmpd.conf
