#!/bin/bash


function getContainerIp() {

  # get the container id
  THIS_CONTAINER_ID_LONG=`cat /proc/self/cgroup | grep 'docker' | sed 's/^.*\///' | tail -n1`

  # take the first 12 characters - that is the format used in /etc/hosts
  THIS_CONTAINER_ID_SHORT=${THIS_CONTAINER_ID_LONG:0:12}

  # search /etc/hosts for the line with the ip address which will look like this:
  #     172.18.0.4    8886629d38e6
  THIS_DOCKER_CONTAINER_IP_LINE=`cat /etc/hosts | grep $THIS_CONTAINER_ID_SHORT`

  # take the ip address from this
  THIS_DOCKER_CONTAINER_IP=`(echo $THIS_DOCKER_CONTAINER_IP_LINE | grep -o '[0-9]\+[.][0-9]\+[.][0-9]\+[.][0-9]\+')`

  echo ${THIS_DOCKER_CONTAINER_IP}
}

WORDPRESS_PATH="/var/www/html"

#Generate default user
if [ ! $(wp --path=${WORDPRESS_PATH} --allow-root core is-installed)]; then
 echo "Generating a default user."
 wp --path=${WORDPRESS_PATH} --allow-root --admin_user="${WORDPRESS_ADMIN_USERNAME}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" --admin_email="${WORDPRESS_ADMIN_EMAIL}" --title="${WORDPRESS_TITLE}" --url="${WORDPRESS_URL}" core install
fi

echo "Generating Vhost for Nginx"

$wordpress_host=$(php -r "echo parse_url(\"${WORDPRESS_URL}\", PHP_URL_HOST);")
$container_ip=$(getContainerIp)

cat > /etc/wordpress/nginx.conf <<-EOF
{
  listen 80;
  server-name ${wordpress_host};

  location ~ \.php$ {
        fastcgi_read_timeout 60000;
        fastcgi_pass   $(container_ip):9000;
        fastcgi_index   index.php;
        fastcgi_param   SCRIPT_FILENAME ${WORDPRESS_PATH}\$fastcgi_script_name;
        include         fastcgi_params;
  }

  location ~ /\.ht {
    deny  all;
  }
}
EOF


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
