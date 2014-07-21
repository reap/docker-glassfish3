# Docker image for providing running Glassfish 3.1.2.2 server
#
# $ docker build -t glassfish3 .
# $ docker run -i -t -p 6048:6048 -p 6080:6080 glassfish3

FROM phusion/baseimage:0.9.11
MAINTAINER Ilari Liukko "ilari.liukko@iki.fi"

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# install necessary applications
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y expect
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-6-jdk

ADD glassfish-3.1.2.2-silent-installation-answers /glassfish-3.1.2.2-silent-installation-answers

# Load Glassfish
RUN wget -q --no-cookies --no-check-certificate "http://download.java.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2-unix.sh" -O /tmp/glassfish-3.1.2.2-unix.sh
RUN sh /tmp/glassfish-3.1.2.2-unix.sh -s -a /glassfish-3.1.2.2-silent-installation-answers

RUN wget -q --no-cookies --no-check-certificate "http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc4.jar" -O /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar

ADD initialize_glassfish.sh /initialize_glassfish.sh
ADD create_domain.sh /create_domain.sh
ADD start_domain.sh /start_domain.sh
ADD enable_secure_admin.sh /enable_secure_admin.sh
ADD stop_domain.sh /stop_domain.sh
ADD check_secure_admin.sh /check_secure_admin.sh

RUN chmod +x /*.sh

# Set up Glassfish
RUN /initialize_glassfish.sh
# RUN /create_domain.sh

EXPOSE 6048 6080

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TODO: replace with runit script, now overrides earlier "/sbin/my_init" call
CMD /start_domain.sh
