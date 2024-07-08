#!/bin/bash
version="0.1.0"

die() {
	echo "${1}"
	exit "${2}"
}

show_version() {
	echo -e "Create Jenkins Keystore v${version}"
	exit 0
}	

show_help() {
	echo -e "\nCreate Jenkins Keystore v${version}\n"
	echo -e "Parameters\n"
	echo -e "  --cert-path: The path to the certificate\n"
	echo -e "  --key-path: The path to the key.\n"
	echo -e "  --jenkins-home: The path to the directory which is your jenkins home. The keystore is deposited in the subfolder 'certs' within that directory.\n"
}

while :; do
	case $1 in
		-h|-\?|--help)
			show_help
			exit
			;;
                --version)
			show_version
                        ;;

		--cert)
                        if [ "$2" ]; then
                                cert_path=$2
                                shift
                        else
                                die 'ERROR: "--cert" requires a non-empty option argument.' 1
                        fi
                        ;;
		--key)
                        if [ "$2" ]; then
                                key_path=$2
                                shift
                        else
                                die 'ERROR: "--key" requires a non-empty option argument.' 1
                        fi
                        ;;
		--jenkins-home)
                        if [ "$2" ]; then
                                jenkins_home=$2
                                shift
                        else
                                die 'ERROR: "--jenkins-home" requires a non-empty option argument.' 1
                        fi
                        ;;
		--)
			shift
			break
			;;
		-?*)
			printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
			;;
		*)
			break
	esac
	shift
done	


openssl pkcs12 -inkey ${key} -in ${cert}  -export -out jenkins_keys.pkcs12
keytool -importkeystore -srckeystore jenkins_keys.pkcs12 -srcstoretype pkcs12 -destkeystore ${jenkins_home}/certs/jenkins2.jks

