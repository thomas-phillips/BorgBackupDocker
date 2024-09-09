#!/bin/bash

mkdir -p /root/.ssh

touch /root/.ssh/id_rsa
echo "${SSH_PRIVATE_KEY}" | base64 -d >/root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

touch /root/.ssh/known_hosts
echo "${SSH_DEVICE}" | base64 -d >/root/.ssh/known_hosts
chmod 600 /root/.ssh/known_hosts

borg list
if [ $? -ne 0 ]; then
	echo "Repository does not exist."
	borg init --encryption=repokey
	echo "Repository created."
fi

echo "Repository exists"
DATE=$(date -u +%Y-%m-%dT%H:%M:%S%Z)
for DIR in $BACKUP_PATHS; do
	NEW_PATH="/mnt/$DIR"
	NEW_PATHS+="$NEW_PATH "
done
borg create ::"$DATE" $NEW_PATHS
