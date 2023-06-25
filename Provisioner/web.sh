#!/bin/bash
yum install wget unzip httpd -y
systemctl start httpd
systemctl enable httpd
wget https://www.tooplate.com/zip-templates/2126_antique_cafe.zip
unzip -o 2126_antique_cafe.zip
cp -r 2126_antique_cafe/* /var/www/html/
systemctl restart httpd
