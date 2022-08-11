# FUCK-DEADBOLT
_v 1.0_

_backup script with integrity check to avoid backing up ransomware corrupted files_

deadbolt is a ransowmare that attacks QNAP NASes. This script to automatically backups important files to an 
external drive only if the content is still intact.
It checks a custom file and doesn't backup if its content is not what is expected.


## requirements

This script runs on linux. It uses `rsync` to back-up and `crontab` to automate it. Both should already be installed in 
every modern linux environment

To automate the backup process you need to have sudo privileges

## usage

### download the script
```shell
git clone https://github.com/FabioBocchini/fuck-deadbolt.git/ 
# if you dont have git installed you can just download the directory
`mkdir /etc/fuck-deadbolt && \
  mv fuck-deadbolt/fuck-deadbolt.config /etc/fuck-deadbolt/fuck-deadbolt.config && \
  mv fuck-deadbolt/fuck-deadbolt.sh $HOME/.local/bin`
```

if you don't have sudo privileges you won't be able to create `/etc/fuck-deadbolt`. Then just save the config file where
you want and edit `fuck-deadbolt.sh` and change the `CONFIG_FILE` variable to point to your file

### edit the configuration
```shell
nano /opt/fuck-deadbolt/fuck-deadbolt.config
```

create the integrity-check file inside the `BACKUP_SOURCE`, with name `INTEGRITY_FILE` and content `INTEGRITY_VALUE`

### run the script
```shell
fuck-deadbolt <command>
```
commands:
- **setup**:
  sets up the crontab job
  overwrites current fuckdeadbolt cron configuration
  must run as sudo
- **remove**:
  removes the crontab job
- **backup**:
  executes a manual backup
- **check**:
  checks if the backup source is intact
