#!/bin/bash
#
#MAILTO=email@domain.com
source $HOME/.keychain/${HOSTNAME}-sh
#
rm /tmp/service_check_errors.txt
rm /tmp/service_check_errors1.txt
rm /tmp/service_check.txt


export WCOLL=$1
#pdsh -R ssh "if /sbin/pidof esmd>>/dev/null; then echo 'ESM is running'; else echo 'ESM is NOT running';fi; if /sbin/pidof adclient>>/dev/null; then echo 'Centrify is running'; else echo 'Centrify is NOT running';fi; if /sbin/pidof zabbix_agentd>>/dev/null; then echo 'Zabbix is running'; else echo 'Zabbix is NOT running';fi;" &>/tmp/service_check.txt 2>/tmp/service_check_errors1.txt
#
#
# Edited to remove Zabbix, since the servers are decom. - Luke - 11/20/2013
#
#
pdsh -R ssh "if /sbin/pidof esmd>>/dev/null; then echo 'ESM is running'; else echo 'ESM is NOT running';fi; if /sbin/pidof adclient>>/dev/null; then echo 'Centrify is running'; else echo 'Centrify is NOT running';fi;"&>/tmp/service_check.txt 2>/tmp/service_check_errors1.txt
grep -v -f $HOME/scripts/exclusion_list.txt /tmp/service_check_errors.1.txt |grep 255 |sort|uniq >/tmp/service_check_errors.txt

if [ -s /tmp/service_check_errors.txt ];
        then
                echo "attached" |mailx -a /tmp/service_check_errors.txt -s "Service Check script errors"  email@domain.com
fi

if [ -s /tmp/service_check.txt ]
        then
                grep -v NOT /tmp/service_check.txt  |mailx -s "Service Check success report"  email@domain.com 
fi

if [ -s /tmp/service_check.txt ]
        then
                grep NOT /tmp/service_check.txt  |mailx -s "Service Check Report"  email@domain.com 
fi

exit 0
