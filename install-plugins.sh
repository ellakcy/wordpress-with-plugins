#!/bin/bash
COMMAND='wp --allow-root --path=/var/www/html'
echo "Installing plugins and themes"

#Append below for the plugin installation

if [ $(${COMMAND} plugin is-installed hello) ]; then
  echo "Removing Useless Plugin hello"
  ${COMMAND} plugin delete hello
fi

if [ $(${COMMAND} plugin is-installed hello) ]; then
  echo "Removing useless plugin akismet"
  ${COMMAND} plugin delete akismet
fi

if [ $(${COMMAND} plugin is-installed wp-piwik) ]; then
  echo "Install piwik plugin for web analytics"
  ${COMMAND} plugin update wp-piwik --activate
else
  echo "Update piwik plugin for web analytics"
  ${COMMAND} plugin install wp-piwik --activate
fi

if [ $(${COMMAND} plugin is-installed twitter) ]; then
  echo "Install twitter plugin for providing a social appearance to the site"
  ${COMMAND} plugin update twitter --activate
else
  echo "Update twitter plugin for providing a social appearance to the site"
  ${COMMAND} plugin install twitter --activate
fi
