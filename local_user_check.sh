#!/bin/bash
check_date=`date -d yesterday +%b" "%e`
grep "$check_date" /var/log/messages | egrep "useradd|userdel|shadow" >/tmp/local_user_report
if test -s /tmp/local_user_report
then 
	cat /tmp/local_user_report| mailx -s "Local user activity on `hostname`" email@domain.com 
#else
#	echo no | mailx -s "No local user activity on `hostname`" email@domain.com 
fi
exit 0
