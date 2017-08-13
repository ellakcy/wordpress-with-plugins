FROM wordpress:php7.0-fpm-alpine
MAINTAINER Dimitrios Desyllas (pc_magas@openmailbox.org)

ENV \
    WORDPRESS_ADMIN_USERNAME='admin' \
    WORDPRESS_ADMIN_PASSWORD='admin123' \
    WORDPRESS_ADMIN_EMAIL="admin@example.com" \
    WORDPRESS_URL="localhost" \
    WORDPRESS_TITLE="My localhost site"

COPY install-plugins.sh /usr/local/bin/install-plugins.sh
COPY ./wp_post_entrypoint.sh /usr/local/bin/wp_post_entrypoint

RUN apk add  --update --no-cache unzip mysql-client git curl &&\
    cd /tmp && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && cd &&\
    chmod +x /tmp/wp-cli.phar &&\
    mv /tmp/wp-cli.phar /usr/local/bin/wp &&\
    chmod +x /usr/local/bin/install-plugins.sh &&\
    chmod +x /usr/local/bin/wp_post_entrypoint &&\
    apk del curl &&\
    rm -rf /var/cache/apk/*

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/bin/wp_post_entrypoint"]
CMD ["php-fpm"]
