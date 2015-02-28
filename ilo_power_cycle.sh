#!/usr/bin/expect
set host [lindex $argv 0]
spawn ssh $host -l Administrator
expect "*assword:"
send "p4ssword\r"
expect "</>hpiLO->"
send "power reset\r"
expect "</>hpiLO->"
send "exit\r"
expect eof
