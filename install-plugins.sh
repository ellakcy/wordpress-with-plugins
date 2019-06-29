#!/bin/bash
COMMAND="sudo -u www-data wp --path=${WORDPRESS_PATH}"
echo "Installing plugins and themes"

#Append below for the plugin installation

if [ $(${COMMAND} plugin is-installed hello) ]; then
  echo "Removing Useless Plugin hello"
  ${COMMAND} plugin delete hello
fi

if [ $(${COMMAND} plugin is-installed wp-piwik) ]; then
  echo "Update piwik plugin for web analytics"
  ${COMMAND} plugin update wp-piwik --activate
else
  echo "Install piwik plugin for web analytics"
  ${COMMAND} plugin install wp-piwik --activate
fi

if [ $(${COMMAND} plugin is-installed twitter) ]; then
  echo "Update twitter plugin for providing a social appearance to the site"
  ${COMMAND} plugin update twitter --activate
else
  echo "Install twitter plugin for providing a social appearance to the site"
  ${COMMAND} plugin install twitter --activate
fi

if [ $(${COMMAND} plugin is-installed cookie-notice) ]; then
  echo "Update cookie notice plugin in order to sho information regarding cookies"
  ${COMMAND} plugin update cookie-notice --activate
else
  echo "Install cookie notice plugin in order to sho information regarding cookies"
  ${COMMAND} plugin install cookie-notice --activate
fi
