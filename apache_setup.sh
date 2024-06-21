#!/bin/bash

# Create the directory for the website
mkdir -p /var/www/gemini

# Copy the mentees_domain.txt file to the web directory
cp /home/cpvbox/Sysad2/Core/mentees_domain.txt /var/www/gemini/mentees_domain.txt
touch /etc/apache2/sites-available/gemini.club.conf

# Create the Apache configuration file for the virtual host
echo "<VirtualHost *:80>
     ServerAdmin webmaster@gemini.club.in
     ServerName gemini.club
     ServerAlias www.gemini.club
     DocumentRoot /var/www
</VirtualHost>" >> /etc/apache2/sites-available/gemini.club.conf

echo "ServerName gemini.club" >> /etc/apache2/apache2.conf

# Enable the new site and disable the default site
a2ensite gemini.club.conf
a2dissite 000-default.conf

# Reload Apache to apply the changes
service apache2 reload

