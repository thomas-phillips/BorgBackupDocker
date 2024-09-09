FROM ubuntu:22.04
RUN apt-get -y update && apt-get -y install borgbackup cron openssh-client

ADD crontab /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron

WORKDIR /borg

ADD backup.sh .
RUN chmod +x backup.sh

RUN touch /var/log/cron.log

ENTRYPOINT [ "/bin/bash", "-c", "cron && tail -f /var/log/cron.log" ]

