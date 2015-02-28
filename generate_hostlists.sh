#!/bin/bash
#
source $HOME/.keychain/${HOSTNAME}-sh
#
#Clean up any previous runs
rm /srv/www/htdocs/all-hosts.list
#domain.com
for host in $( host -l domain.com |grep nasd|egrep -v "xtp|tru|ilo|eth|dmx|9500|car|mcast|ashi|borg" |cut -f1 -d " "); do if ping -c1 -W2 $host >>/dev/null; then echo $host; fi;done >> /srv/www/htdocs/all-hosts.list
#borg02.domain.com
for host in $( host -l borg02.domain.com |egrep -v "pri|sec|llp|name"|cut -f1 -d " "); do if ping -c1 -W2 $host >>/dev/null; then echo $host; fi;done >>/srv/www/htdocs/all-hosts.list
#ny.domain.com
for host in $( host -l ny.domain.com |egrep -v "pri|sec|llp|name|ny4|raven|tardis|eth|dds|dhcp|centera|colo|cardinal|cua|netapp|borg"|cut -f1 -d " "); do if ping -c1 -W2 $host >>/dev/null; then echo $host; fi;done >>/srv/www/htdocs/all-hosts.list
#autoborg.ny.domain.com
for host in $( ssh auto1 -l root 'host -l autoborg.ny.domain.com |egrep -v "pri|sec|llp|name|ny4|raven|tardis|eth|dds|dhcp|centera|colo|cardinal|cua|netapp|borgdns"|cut -f1 -d " "'); do if ping -c1 -W2 $host >>/dev/null; then echo $host; fi;done >> /srv/www/htdocs/all-hosts.list
#pops.domain.com
for host in $( ssh pops-it01.pops -l root 'host -l pops.domain.com |egrep -v "borg|pri|sec|llp|name|ny4|raven|tardis|eth|dds|dhcp|centera|colo|cardinal|cua|netapp|borgdns"|cut -f1 -d " "'); do if ping -c1 -W2 $host >>/dev/null; then echo $host; fi;done >> /srv/www/htdocs/all-hosts.list
#borg.pops.domain.com
for host in $( host -l borg.pops.domain.com |egrep -v "COST|pri|sec|llp|name"|cut -f1 -d " "); do if ping -c1 -W2 $host >>/dev/null; then echo $host; fi;done >> /srv/www/htdocs/all-hosts.list
#cob.domain.com
for host in $( host -l cob.domain.com |egrep -v "COST|borg|pri|sec|llp|name|nasd"|cut -f1 -d " "); do if ping -c1 -W2 $host >>/dev/null; then echo $host; fi;done >> /srv/www/htdocs/all-hosts.list
#borg.cob.domain.com
for host in $( host -l borg.cob.domain.com |egrep -v "COST|pri|sec|llp|name|nasd"|cut -f1 -d " "); do if ping -c1 -W2 $host >>/dev/null; then echo $host; fi;done >> /srv/www/htdocs/all-hosts.list
exit 0
