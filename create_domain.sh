#!/bin/bash
#
# Script for creating glassfish domain with given name and port base.
# Script also creates runit-script for starting domain when image is started
#
# Usage:
#   sh create_domain.sh [domain-name] [port-base] [config-script]
#
# If domain name and/or port base are left out, defaults "default" and "5000" are used.

DOMAIN_NAME=$1
PORT_BASE=$2
DOMAIN_CONFIG_SCRIPT=$3

if [ -z "$DOMAIN_NAME" ]
  then
    DOMAIN_NAME="default"
fi

if [ -z "$PORT_BASE" ]
  then
    PORT_BASE="5000"
fi

ADMIN_PORT=$(expr ${PORT_BASE} + 48)

echo "Creating domain $DOMAIN_NAME with portbase $PORT_BASE and admin port $ADMIN_PORT"

${GLASSFISH_HOME}/bin/asadmin --user admin --passwordfile glassfish.passwords create-domain --portbase ${PORT_BASE} --keytooloptions CN=localhost ${DOMAIN_NAME}

if [ ! $? -eq 0 ]
  then
    echo "Creating domain failed, aborting script"
    exit 1
fi


# add domain to be started when image is started
mkdir /etc/service/glassfish-domain-${DOMAIN_NAME}
cat >/etc/service/glassfish-domain-${DOMAIN_NAME}/run <<EOL
#!/bin/sh

$GLASSFISH_HOME/bin/asadmin start-domain --debug -v ${DOMAIN_NAME}
EOL
chmod +x /etc/service/glassfish-domain-${DOMAIN_NAME}/run

# start the domain and enable remote admistration
${GLASSFISH_HOME}/bin/asadmin start-domain ${DOMAIN_NAME}
${GLASSFISH_HOME}/bin/asadmin --user admin --passwordfile glassfish.passwords --port ${ADMIN_PORT} enable-secure-admin

# run domain custom configuration here
if [ -n "$DOMAIN_CONFIG_SCRIPT" ]
  then
    source ${DOMAIN_CONFIG_SCRIPT}
fi

# stop domain
$GLASSFISH_HOME/bin/asadmin stop-domain ${DOMAIN_NAME}
