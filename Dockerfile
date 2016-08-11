FROM wordpress:fpm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y unzip &&\
    rm -rf /var/cache/apt/*

ENV PLUGIN_URL https://downloads.wordpress.org/plugin

ENV PIWIK_PLUGIN_VERSION 1.0.9
RUN curl -o /tmp/wp-piwik.${PIWIK_PLUGIN_VERSION}.zip  ${PLUGIN_URL}/wp-piwik.${PIWIK_PLUGIN_VERSION}.zip &&\
    unzip /tmp/wp-piwik.${PIWIK_PLUGIN_VERSION}.zip -d /tmp &&\
    chown www-data:www-data /tmp/wp-piwik &&\
    mv /tmp/wp-piwik /usr/src/wordpress/wp-content/plugins/&&\
    find /usr/src/wordpress/wp-content/plugins/wp-piwik -type d -exec chmod 755 {} + &&\
    find /usr/src/wordpress/wp-content/plugins/wp-piwik -type d -exec chmod 633 {} + &&\  
    ls -l  /usr/src/wordpress/wp-content/plugins/
