#!/bin/bash

# this is a second sample script to check Azure VM customscript extension
# this script install Ansible on a RHEL machine

echo $1 > /tmp/parameter.txt

# enregistrement de la VM aupres de Red Hat si besoin
# subscription-manager register --auto-attach

# Update si necessaire
# yum -y update

curl -H "Content-Type: application/json" -d "{\"text\": \"Debut du script deploy2.sh \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9

# The easiest way to install Ansible is by adding a third-party repository named EPEL (Extra Packages for Enterprise Linux), which is maintained over at http://fedoraproject.org/wiki/EPEL. You can easily add the repo by running the following command:
curl -H "Content-Type: application/json" -d "{\"text\": \"ajout du depot EPEL \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Installation de Ansible
curl -H "Content-Type: application/json" -d "{\"text\": \"Installation Ansible \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9
yum -y install ansible

curl -H "Content-Type: application/json" -d "{\"text\": \"Fin du script deploy2.sh \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9
echo "customscript done" > /tmp/results.txt

exit 0
