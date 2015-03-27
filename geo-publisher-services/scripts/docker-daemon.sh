#!/bin/bash

set -e

# Install zookeeper:
apt-get -qy update
apt-get -qy install \
	byobu \
	zookeeper \
	zookeeper-bin \
	zookeeperd \
	maven
apt-get -qy upgrade

# Configure the docker daemon:
cp /vagrant/scripts/docker-settings /etc/default/docker

# Setup zookeeper and exhibitor: 
if [[ ! -e /opt/exhibitor ]]; then

	# Package exhibitor:
	cd /opt
	mkdir exhibitor
	cd exhibitor
	wget -q https://raw.github.com/Netflix/exhibitor/master/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml
	mvn package
	cd target
	cp exhibitor*.jar /opt/exhibitor.jar 
	
	cat > /etc/init/exhibitor.conf <<-EOT
		description "Exhibitor"
		
		start on vagrant-mounted
		stop on runlevel [!2345]
		
		expect fork
		
		respawn
		respawn limit 0 5
		
		script
			cd /opt
			java -jar exhibitor.jar --port 8081 -c file > /var/log/exhibitor.log 2>&1
			emit exhibitor-running
		end script	
EOT

	initctl reload-configuration
	service exhibitor start

fi