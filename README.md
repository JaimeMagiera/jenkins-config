## Jenkins Config

This repository contains a handful of Jenkins resources. In particular, I wanted to provide resources for home lab users to run Jenkins over SSL in a container, automating as much of the process as possible. 

### Build the Container

Clone this repository and ```cd``` into it. 

```
podman build -t myjenkins-blueocean:2.452.2 .
```


### Generate the SSL Key and Certificate

Use your favorite tool to generate an SSL key and certificate. If you want to create a self-signed cert, you can do the flllowing...

```
openssl genrsa -des3 -out domain.key 4096
``` 

### Generate the Keystore

I've written a [script](create-jenkins-keystore.sh) that creates a PKCS12 file from the key and certificate, then a keystore from that. The resulting keystore is copied to the location provided via the ```--jenkins-home``` flag. Note: Use the same password for the PKCS12 file and keystore. 

```
create-jenkins-keystore.sh --key ${KEY_PATH} --cert ${CERT_PATH} --jenkins-home ${JENKINS_HOME_PATH}
```

### Save the keystore password as a Podman secret

Run the following command to save the jenkins options necessary to launch with SSL enabled as a Podman secret. Replace "keystorepassword" with the password you used above. Using podman secrets avoids you having to put the keystore password in the startup script.

```
printf "--httpPort=-1 --httpsPort=8443 --httpsKeyStore=/var/jenkins_home/certs/jenkins.jks --httpsKeyStorePassword=keystorepassword" | podman secret create jenkins-opts -
```

### Start the Container

The [start-jenkins.sh script](start-jenkins.sh) will launch the container with the correct parameters, including keystore location and password, for SSL. 

 



