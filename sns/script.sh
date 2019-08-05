# /bin/bash

for TOPIC in $(cat topics.txt); do
   for EMAIL in $(cat emails.txt); do
     # echo "${TOPIC} ${NAME}"
     aws sns subscribe --topic-arn ${TOPIC} --protocol email --notification-endpoint ${EMAIL} --region=us-east-1
   done;
done;
