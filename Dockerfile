FROM wordpress:4.7.2
MAINTAINER Dimitrios Desyllas (pc_magas@openmailbox.org)

ENV \
    DEBIAN_FRONTEND=noninteractive \
    WORDPRESS_ADMIN_USERNAME='admin' \
    WORDPRESS_ADMIN_PASSWORD='admin123' \
    WORDPRESS_ADMIN_EMAIL="admin@example.com" \
    WORDPRESS_URL="localhost" \
    WORDPRESS_TITLE="My localhost site"

COPY install-plugins.sh /usr/bin/install-plugins.sh
COPY docker-entrypoint.sh /usr/bin/entrypoint

RUN apt-get update &&\
    apt-get install -y unzip mysql-client git &&\
    rm -rf /var/cache/apt/* &&\
    cd && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
    chmod +x wp-cli.phar &&\
    mv wp-cli.phar /usr/local/bin/wp &&\
    chmod +x /usr/bin/install-plugins.sh &&\
    chmod +x /usr/bin/entrypoint


ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]
