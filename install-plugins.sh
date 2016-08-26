#!/bin/bash
COMMAND='wp --allow-root --path=/var/www/html'
echo "Installing plugins and themes"

#Append below for the plugin installation

echo "Removing Useless Plugins"
${COMMAND} plugin delete hello

echo "Install piwik plugin for web analytics"
${COMMAND} plugin install wp-piwik

echo "Install twitter plugin for providing a social appearance to the site"
${COMMAND} plugin install twitter
