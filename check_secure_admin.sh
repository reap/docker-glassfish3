#!/usr/bin/expect -f

spawn /opt/glassfish3/bin/asadmin --port 6048 get secure-admin.enabled
expect "Enter admin user name>"
send "admin\n"
expect "Enter admin password for user"
send "admin\n"
expect eof
exit