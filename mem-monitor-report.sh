#This job will pull a report and record per-process memory usage.
#Put in cron and run as needed
#
(echo -n "START " ; date;free -m ; ps -eo pid,rss,vsize,fname,args|sort -k2 -nr|head -10l ; echo -n "END " ;date) >> /var/tmp/mem_monitor.log
