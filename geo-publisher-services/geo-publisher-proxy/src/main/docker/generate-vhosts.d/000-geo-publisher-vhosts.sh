#!/bin/bash

function writeVhostStart {
	VHOST_FILE=/etc/apache2/sites-available/vhost.$1.conf
	cat > $VHOST_FILE <<-EOT
		<VirtualHost *:80>
			ServerName $1
			
			Redirect permanent / https://$1/
		</VirtualHost>
		
		<VirtualHost *:443>
			ServerName $1
			
			SSLEngine On
			SSLCertificateFile /etc/ssl/certs/cert.pem
			SSLCertificateKeyFile /etc/ssl/private/private.key
			SSLCertificateChainFile /opt/certs/cabundle.pem
			
			DocumentRoot /var/www/geo-publisher
			
			<Location />
				Options -Indexes
			</Location>
			
			ProxyPreserveHost On
EOT
}

function writeVhostEnd {
	VHOST_FILE=/etc/apache2/sites-available/vhost.$1.conf
	echo "</VirtualHost>" >> $VHOST_FILE
	a2ensite vhost.$1.conf
}

function writeGeoserver {
	cat >> $1 <<-EOT
		ProxyPass /geoserver		ajp://geoserver:8009/geoserver
		ProxyPassReverse /geoserver	ajp://geoserver:8009/geoserver
		
EOT
}

function writeWeb {
	cat >> $1 <<-EOT
		ProxyPass /metadata !
		ProxyPass /icons !
	
		<Location /metadata>
			Options +Indexes
			Dav On
		</Location>
		
		ProxyPass /				http://web:9000/
		ProxyPassReverse /		http://web:9000/
EOT
}

cat >> /etc/apache2/sites-available/000-default.conf <<-EOT
<VirtualHost *:80>
	RedirectMatch permanent (.*)$ https://$PUBLISHER_WEB_DOMAIN/
</VirtualHost>
<VirtualHost *:443>
	RedirectMatch permanent (.*)$ https://$PUBLISHER_WEB_DOMAIN/
	
	SSLEngine On
	SSLCertificateFile /etc/ssl/certs/cert.pem
	SSLCertificateKeyFile /etc/ssl/private/private.key
	SSLCACertificateFile /opt/certs/cabundle.pem
</VirtualHost>
EOT
a2ensite 000-default
a2dissite default-ssl

if [ "$PUBLISHER_GEOSERVER_DOMAIN" == "$PUBLISHER_WEB_DOMAIN" ]; then
	# Write to the same vhost file:
	writeVhostStart $PUBLISHER_WEB_DOMAIN
	
	writeGeoserver /etc/apache2/sites-available/vhost.$PUBLISHER_WEB_DOMAIN.conf
	writeWeb /etc/apache2/sites-available/vhost.$PUBLISHER_WEB_DOMAIN.conf

	writeVhostEnd $PUBLISHER_WEB_DOMAIN	
else
	# Write to separate vhost files:
	writeVhostStart $PUBLISHER_WEB_DOMAIN
	
	writeWeb /etc/apache2/sites-available/vhost.$PUBLISHER_WEB_DOMAIN.conf

	writeVhostEnd $PUBLISHER_WEB_DOMAIN	

	writeVhostStart $PUBLISHER_GEOSERVER_DOMAIN	
	
	writeGeoserver /etc/apache2/sites-available/vhost.$PUBLISHER_GEOSERVER_DOMAIN.conf

	writeVhostEnd $PUBLISHER_GEOSERVER_DOMAIN	
fi

cat /etc/apache2/sites-available/vhost.$PUBLISHER_WEB_DOMAIN.conf
cat /etc/apache2/sites-available/vhost.$PUBLISHER_GEOSERVER_DOMAIN.conf