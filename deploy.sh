#!/bin/bash

# this is a sample script to check Azure VM customscript extension

curl -H "Content-Type: application/json" -d "{\"text\": \"Debut du script deploy.sh \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9

echo "customscript done" > /tmp/results.txt

curl -H "Content-Type: application/json" -d "{\"text\": \"Fin du script deploy.sh \"}" https://outlook.office.com/webhook/555aa7fc-ea71-4fb7-ae9e-755bba4d04ed@72f988bf-86f1-41af-91ab-2d7cd011db47/IncomingWebhook/16085df23e564bb9876842605ede3af2/51dab674-ad95-4f0a-8964-8bdefc25b6d9

exit 0
