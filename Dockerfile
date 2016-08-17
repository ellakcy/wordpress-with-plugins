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

ENTRYPOINT /usr/bin/install-plugins.sh
CMD ["apache2-foreground"]
