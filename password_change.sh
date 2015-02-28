#!/usr/bin/expect

spawn passwd [lindex $argv 0]
set password [lindex $argv 1]
expect "*assword:"
send "$password\r"
expect "*assword:"
send "$password\r"
expect eof
