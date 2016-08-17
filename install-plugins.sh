#!/bin/bash

if ! [ -e index.php -a -e wp-includes/version.php ]; then
		echo >&2 "WordPress not found in $(pwd) - copying now..."
		if [ "$(ls -A)" ]; then
			echo >&2 "WARNING: $(pwd) is not empty - press Ctrl+C now if this is an error!"
			( set -x; ls -A; sleep 10 )
		fi
		tar cf - --one-file-system -C /usr/src/wordpress . | tar xf -
		echo >&2 "Complete! WordPress has been successfully copied to $(pwd)"
		if [ ! -e .htaccess ]; then
			# NOTE: The "Indexes" option is disabled in the php:apache base image
			cat > .htaccess <<-'EOF'
				# BEGIN WordPress
				<IfModule mod_rewrite.c>
				RewriteEngine On
				RewriteBase /
				RewriteRule ^index\.php$ - [L]
				RewriteCond %{REQUEST_FILENAME} !-f
				RewriteCond %{REQUEST_FILENAME} !-d
				RewriteRule . /index.php [L]
				</IfModule>
				# END WordPress
			EOF
			chown www-data:www-data .htaccess
		fi
fi

: "${WORDPRESS_DB_HOST:=mysql}"
# if we're linked to MySQL and thus have credentials already, let's use them

: ${WORDPRESS_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}
if [ "$WORDPRESS_DB_USER" = 'root' ]; then
  : ${WORDPRESS_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
fi

: ${WORDPRESS_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
: ${WORDPRESS_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-wordpress}}

if [ -z "$WORDPRESS_DB_PASSWORD" ]; then
  echo >&2 'error: missing required WORDPRESS_DB_PASSWORD environment variable'
  echo >&2 '  Did you forget to -e WORDPRESS_DB_PASSWORD=... ?'
  echo >&2
  echo >&2 '  (Also of interest might be WORDPRESS_DB_USER and WORDPRESS_DB_NAME.)'
  exit 1
fi

if [ ! -e wp-config.php ]; then
  echo "Generatiing wp-config"
  wp --path=/var/www/html --allow-root core config --dbname=${WORDPRESS_DB_NAME} --dbpass=${WORDPRESS_DB_PASSWORD} --dbuser=${WORDPRESS_DB_USER} --dbhost=${WORDPRESS_DB_HOST} <<PHP
  // If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact
  // see also http://codex.wordpress.org/Administration_Over_SSL#Using_a_Reverse_Proxy
  if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
  	$_SERVER['HTTPS'] = 'on';
  }
PHP
  chown www-data:www-data wp-config.php
fi

exec "$@"
