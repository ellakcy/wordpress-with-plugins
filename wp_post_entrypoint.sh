#!/bin/bash

#Generate default user
if [ ! $(wp --path=/var/www/html --allow-root core is-installed)]; then
 echo "Generating a default user."
 wp --path=/var/www/html --allow-root --admin_user="${WORDPRESS_ADMIN_USERNAME}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" --admin_email="${WORDPRESS_ADMIN_EMAIL}" --title="${WORDPRESS_TITLE}" --url="${WORDPRESS_URL}" core install
fi

version=$(wp --path=/var/www/html --allow-root core version)

if [ $version != ${WORDPRESS_VERSION} ]; then
	echo "Outdated version try to update"
	wp --path=/var/www/html --allow-root core update
fi

echo "Updating existing plugins and themes"
wp --path=/var/www/html --allow-root plugin update-all
wp --path=/var/www/html --allow-root theme update-all

echo "Fixing Permissions"
chown www-data:www-data -R .

#Installing 3rd party plugins
/usr/bin/install-plugins.sh

echo "Executing 3rd party scripts."
exec "$@"
echo "3rd party scripts executed."
