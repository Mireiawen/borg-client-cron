# BorgBackup
Docker Container for the [BorgBackup](https://www.borgbackup.org/) to be used as backup client with timed cron jobs

Dockerfile contains the following
- [Bitnami Minideb](https://hub.docker.com/r/bitnami/minideb/) based on [Debian Buster](https://www.debian.org/)
- BorgBackup
- OpenSSH client
- Cron daemon

## Running
Run this container, mount the SSH keys from `/root/backup` which contains `.ssh` folder with `config` and actual keys, mount the `/data/file` from `data_files` volume and back up the `/data` folder to `remotebackup` destination that is configured in the SSH configuration mounted.

Keep 14 daily backups, 5 weekly backups and 12 monthly backups and run the backup job daily at 03.15.

```
docker run \
	--detach \
	--restart 'unless-stopped' \
	--volume '/root/backup:/root'
	--mount 'source=data_files,target=/data/file' \
	--env BORG_REPO="remotebackup:/home/datafiles/repository.borg" \
	--env BORG_PASSPHRASE="secret_pass" \
	--env BORG_SOURCES="/data" \
	--env BORG_KEEP="14 5 12" \
	--env CRON="15 03 * * *" \
	mireiawen/borg-client-cron
```
