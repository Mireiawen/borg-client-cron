ARG borgbackup_version="1.1.11"

# Use the base client image
FROM "mireiawen/borg-client:${borgbackup_version}"
ARG borgbackup_version

# Add the labels for the image
LABEL name="borg-backup"
LABEL summary="Docker Container for the BorgBackup to be used as backup server"
LABEL maintainer="Mira 'Mireiawen' Manninen"
LABEL version="${borgbackup_version}"

# Set up environment variables
ENV BORG_REPO="/mnt/repo.borg"
ENV BORG_PASSPHRASE="really_secret"
ENV BORG_SOURCES="/home /var"
ENV BORG_KEEP="14 5 6"
ENV CRON="0 3 * * *"

# Install the cron and logger
RUN install_packages \
	"cron" \
	"syslog-ng-core" \
	"syslog-ng-mod-journal"
COPY "syslog-ng.conf" "/etc/syslog-ng/syslog-ng.conf"

# Copy the job script
COPY "job.sh" "/job.sh"

# Set the entry point
COPY "start.sh" "/start.sh"
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/start.sh" ]
