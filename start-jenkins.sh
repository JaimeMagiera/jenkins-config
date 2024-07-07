#!/bin/bash

podman run --name jenkins-blueocean \
	--restart=on-failure \
	--detach \
	--rm \
	--privileged \
	--network bridge \
	--env DOCKER_HOST=tcp://docker:2376 \
	--env DOCKER_CERT_PATH=/certs/client \
	--env DOCKER_TLS_VERIFY=1 \
	--env DOCKER_TLS_CERTDIR=/certs \
 	--publish 8443:8443 \
	--secret=jenkins-opts,type=env,target=JENKINS_OPTS \
	--volume "$JENKINS_HOME":/var/jenkins_home \
        myjenkins-blueocean:2.452.2-ssl

podman container ls
