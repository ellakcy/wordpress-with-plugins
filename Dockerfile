FROM wordpress

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y unzip mysql-client &&\
    rm -rf /var/cache/apt/*


RUN cd && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar&&\
    chmod +x wp-cli.phar&&\
    mv wp-cli.phar /usr/local/bin/wp

COPY install-plugins.sh /usr/bin/install-plugins.sh
RUN chmod +x /usr/bin/install-plugins.sh

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV WORDPRESS_ADMIN_USERNAME='admin'
ENV WORDPRESS_ADMIN_PASSWORD='admin'
ENV WORDPRESS_ADMIN_EMAIL="admin@example.com"
ENV WORDPRESS_URL="localhost"
ENV WORDPRESS_TITLE="My localhost site"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/install-plugins.sh"]
