#!/usr/bin/expect

set password [lindex $argv 1]
spawn ssh -l root [lindex $argv 0] "ps axu |grep -i java | grep -v grep" 
expect "*assword:"
send "$password\r"
expect eof


