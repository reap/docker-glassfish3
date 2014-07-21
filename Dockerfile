# Docker image for providing running Glassfish 3.1.2.2 server using OpenJDK 1.6
#
#     https://github.com/reap/docker-glassfish3
#
# Build and run with:
#     $ docker build -t glassfish3 .
#     $ docker run -i -t -p 6048:6048 -p 6080:6080 glassfish3

FROM phusion/baseimage:0.9.11
MAINTAINER Ilari Liukko "ilari.liukko@iki.fi"

# Set correct environment variables.
ENV HOME /root

# install necessary applications
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y expect
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-7-jre-headless=7u51-2.4.6-1ubuntu4
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-7-jre=7u51-2.4.6-1ubuntu4
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-7-jdk=7u51-2.4.6-1ubuntu4

ADD glassfish-3.1.2.2-silent-installation-answers /glassfish-3.1.2.2-silent-installation-answers

# Load Glassfish
RUN wget -q --no-cookies --no-check-certificate "http://download.java.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2-unix.sh" -O /tmp/glassfish-3.1.2.2-unix.sh
RUN sh /tmp/glassfish-3.1.2.2-unix.sh -s -a /glassfish-3.1.2.2-silent-installation-answers

RUN wget -q --no-cookies --no-check-certificate "http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc4.jar" -O /opt/glassfish3/glassfish/lib/postgresql-9.1-903.jdbc4.jar

ADD initialize_glassfish.sh /initialize_glassfish.sh
ADD glassfish.passwords /glassfish.passwords

RUN mkdir /etc/service/glassfish
ADD run_glassfish.sh /etc/service/glassfish/run
RUN chmod +x /etc/service/glassfish/run

RUN chmod +x /*.sh

# Set up Glassfish
RUN /initialize_glassfish.sh

# expose http-port and admin console port
EXPOSE 6048 6080

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
