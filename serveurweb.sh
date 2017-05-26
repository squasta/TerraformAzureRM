#!/bin/bash
echo "Hello, Azure" > index.html
nohup busybox httpd -f -p 8080 &
# busybox est un web server par defaut sur Ubuntu
# nohup et & pour demarrer en background le serveur web
