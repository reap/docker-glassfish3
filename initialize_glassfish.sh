#!/bin/bash

# create domain
/opt/glassfish3/bin/asadmin --user admin --passwordfile glassfish.passwords create-domain --portbase 6000 example

# start the domain and enable remote admistration
/opt/glassfish3/bin/asadmin start-domain example
/opt/glassfish3/bin/asadmin --user admin --passwordfile glassfish.passwords --port 6048 enable-secure-admin

# stop domain
/opt/glassfish3/bin/asadmin stop-domain example




