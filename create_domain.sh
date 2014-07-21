#!/usr/bin/expect -f

spawn /opt/glassfish3/bin/asadmin create-domain --portbase 6000 example
expect "user name"
send "admin\n"
expect "password"
send "admin\n"
expect "password again"
send "admin\n"
expect eof
exit
