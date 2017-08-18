#!/bin/bash

WORDPRESS_PATH="/var/www/html"

echo "Fixinf permissions"
find ${WORDPRESS_PATH} -iname "*.php" | xargs chmod +x

#Generate default user
if [ ! $(wp --path=${WORDPRESS_PATH} --allow-root core is-installed)]; then
 echo "Generating a default user."
 wp --path=${WORDPRESS_PATH} --allow-root --admin_user="${WORDPRESS_ADMIN_USERNAME}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" --admin_email="${WORDPRESS_ADMIN_EMAIL}" --title="${WORDPRESS_TITLE}" --url="${WORDPRESS_URL}" core install
fi

version=$(wp --path=${WORDPRESS_PATH} --allow-root core version)

if [ $version != ${WORDPRESS_VERSION} ]; then
	echo "Outdated version try to update"
	wp --path=${WORDPRESS_PATH} --allow-root core update
fi

echo "Updating existing plugins and themes"
wp --path=${WORDPRESS_PATH} --allow-root plugin update-all
wp --path=${WORDPRESS_PATH} --allow-root theme update-all

echo "Fixing Permissions"
chown www-data:www-data -R .

#Installing 3rd party plugins
/usr/local/bin/install-plugins.sh
