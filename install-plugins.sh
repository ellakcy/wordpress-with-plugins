#!/bin/bash
COMMAND='wp --allow-root --path=/var/www/html'

#Append below for the plugin installation


#DO NOT REMOVE THIS LINE ALWAYS MUST BE ON THE END
#Also DO NOT Install plugins and themes below this command there won't be installled
/usr/sbin/apache2ctl -D FOREGROUND
