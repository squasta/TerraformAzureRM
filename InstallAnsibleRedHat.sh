#!/bin/bash

# this is a sample script to use with Azure VM customscript extension to setup Ansible on RHEL 

curl -H "Content-Type: application/json" -d "{\"text\": \"Debut du script deploy.sh \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9

# enregistrement de la VM aupres de Red Hat si besoin
# subscription-manager register --auto-attach

curl -H "Content-Type: application/json" -d "{\"text\": \"Ajout du depot EPEL \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9
# The easiest way to install Ansible is by adding a third-party repository named EPEL (Extra Packages for Enterprise Linux), which is maintained over at http://fedoraproject.org/wiki/EPEL. You can easily add the repo by running the following command:
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Update si necessaire
# yum -y update

curl -H "Content-Type: application/json" -d "{\"text\": \"yum -y ansible \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9
# Installation de Ansible
yum -y install ansible

# check de la version d Ansible
# ansible --version

echo "customscript done" > /tmp/results.txt

curl -H "Content-Type: application/json" -d "{\"text\": \"Fin du script deploy.sh \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9

exit 0
