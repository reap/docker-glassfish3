docker-glassfish3
=================

Docker base-image for providing Glassfish 3.1.2.2 server running on 1.7 JDK.

## Usage

Example Dockerfile for image created on this. Creates domain called example and intializes it to be started with runit.

    # Docker image for providing running Glassfish 3.1.2.2 server
    #
    # $ docker build -t glassfish3-example .
    # $ docker run -i -t -p 6048:6048 -p 6080:6080 glassfish3-example
    
    FROM reap/docker-glassfish3
    
    # create domain
    RUN /create_domain.sh example 6000
    
    # expose domains admin and http-port
    EXPOSE 6048 6080
