FROM wordpress:php7.0-fpm-alpine
MAINTAINER Dimitrios Desyllas (pc_magas@openmailbox.org)

ENV \
    WORDPRESS_ADMIN_USERNAME='admin' \
    WORDPRESS_ADMIN_PASSWORD='admin123' \
    WORDPRESS_ADMIN_EMAIL="admin@example.com" \
    WORDPRESS_URL="localhost" \
    WORDPRESS_TITLE="My localhost site"
    
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
COPY wp_post_entrypoint.sh /usr/local/bin/wp_post_entrypoint
COPY docker_entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/install-plugins.sh &&\
    chmod +x /usr/local/bin/wp_post_entrypoint &&\
    chmod +x /usr/local/bin/docker-entrypoint.sh &&\
    apk add  --update --no-cache unzip mysql-client git curl &&\
    cd /tmp && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && cd &&\
    chmod +x /tmp/wp-cli.phar &&\
    mv /tmp/wp-cli.phar /usr/local/bin/wp &&\
    apk del curl &&\
    rm -rf /var/cache/apk/* &&\
    mkdir -p /etc/nginx/conf.d/ &&\
    mkdir -p /etc/nginx/sites-available/ &&\
    ln -s  /etc/nginx/conf.d/ /etc/nginx/sites-available

# For alpine based-nginx
VOLUME /etc/nginx/conf.d/

# For debian based
VOLUME /etc/nginx/sites-available/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
