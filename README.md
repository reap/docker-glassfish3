docker-glassfish3
=================

Docker image for providing running Glassfish 3.1.2.2 server with 1.6 JDK.

    docker build -t glassfish3 .
    docker run -i -t -p 6048:6048 -p 6080:6080 glassfish3
