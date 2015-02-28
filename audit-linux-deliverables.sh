#!/bin/bash
# This script pulls Linux deliverables on the server its ran from, then zip files, and mail them to specified user.
# Luke Guerry
#
#
d=`date '+%Y%m%d'`
h=`hostname -f`

dzdo cat /etc/passwd >/tmp/$h-a-passwd.txt
dzdo cat /etc/shadow >/tmp/$h-b-shadow.txt
dzdo cat /etc/exports >/tmp/$h-c-exports.txt
dzdo cat /etc/fstab >/tmp/$h-d-fstab.txt
dzdo cat /etc/ntp.conf >/tmp/$h-e-ntpconf.txt
dzdo cat /etc/syslog-ng/syslog-ng.conf >/tmp/$h-f-syslogconf.txt
dzdo cat /etc/login.defs >/tmp/$h-g-defaultlogin.txt
dzdo showmount -e >/tmp/$h-h-showmount.txt 
dzdo netstat -an >/tmp/$h-i-netstat.txt
dzdo ps axuf > /tmp/$h-j-processes.txt
dzdo ls -lh /root/.ssh/authorized_keys > /tmp/$h-k-sshtrust.txt
dzdo cat /etc/securetty > /tmp/$h-m-securetty.txt
dzdo cat /etc/ssh/sshd_config > /tmp/$h-l-sshdconfig.txt
dzdo crontab -u root -l > /tmp/$h-n-crontab.txt
dzdo rpm -qa > /tmp/$h-p-rpmlist.txt
dzdo cat /etc/issue > /tmp/$h-q-os.txt
dzdo hostname -f >>/tmp/$h-q-os.txt 
dzdo uname -r >> /tmp/$h-q-os.txt
dzdo zip /tmp/$h-audit-$d.zip /tmp/$h-*.txt
sleep 20
dzdo chmod 777 /tmp/$h-audit-$d.zip




mailx -a /tmp/$h-audit-$d.zip -s "Linux Deliverables for $h - $d" email@email..com <<-EOF
