#!/usr/bin/env /bin/bash

Green="\033[1;92m" # Green
Red="\033[0;31m"   # Red
Reset="\033[0m"    # Text Reset

CURRENT_VERSION="1.0"
CURRENT_DIR="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
CONFIG_FILE="$/etc/fuck-deadbolt/fuck-deadbolt.config"
EXECUTABLE_NAME=`basename $0`

if test -f ${CONFIG_FILE}; then
  . ${CONFIG_FILE}
else
  echo "config file not found, exiting"
  exit 1
fi

function get_cron_d {
  if [ -n "${CRON_D_PATH}" ] ; then
    cron_d_path=${CRON_D_PATH}
    return 0
  fi
  cron_d_path="/etc/cron.d"
  return 0
}

function setup {
  echo -e "${Green}setting up fuckdeadbolt cron job${Reset}"
  get_cron_d
  cron_d_file="${cron_d_path}/fuckdeadbolt"
  echo "${BACKUP_TIME_MINUTES} ${BACKUP_TIME_HOUR} * * ${BACKUP_TIME_DAY} root ${CURRENT_DIR}/${EXECUTABLE_NAME} backup" > ${cron_d_file}
  echo -e "${Green}done${Reset}"
}

function remove {
  echo -e "${Green}removing fuckdeadbolt cron configuration${Reset}"
  get_cron_d
  cron_d_file="${cron_d_path}/fuckdeadbolt"
  rm $cron_d_file
  echo -e "${Green}done${Reset}"
}

function check_integrity {
  echo -e "${Green}checking integrity_file${Reset}"
  integrity_file="${BACKUP_SOURCE}/${INTEGRITY_FILE}"
  integrity_value=$(<$integrity_file)
  if [[ "${integrity_value}" == "${INTEGRITY_VALUE}" ]]; then
    echo -e "${Green}integrity file is intact${Reset}"
    return 0
  else
    echo -e "${Red}integrity file is not intact, expecting '${INTEGRITY_VALUE}' but read '${integrity_value}'${Reset}"
    return 1
  fi
}

function backup {
  echo -e "${Green}starting the backup${Reset}"
  check_integrity
  if [[ $? > 0 ]]; then
    echo -e "${Red}aborting${Reset}"
    return 1
  fi
  rsync -zrah --progress $BACKUP_SOURCE $BACKUP_DESTINATION
  echo -e "${Green}done${Reset}"
}

while [[ $# -gt 0 ]]; do
  key="$1"

  case "$key" in
  setup)
    setup
    exit
    ;;
  remove)
    remove
    exit
    ;;
  backup)
    backup
    exit
    ;;
  check)
    check_integrity
    exit
    ;;
  esac

  shift
done

echo -en """fuck-deadbolt version ${CURRENT_VERSION}

commands:
  - ${Green}setup${Reset}:
    sets up the crontab job
    overwrites current fuckdeadbolt cron configuration
    must run as sudo
  - ${Green}remove${Reset}:
    removes the crontab job
  - ${Green}backup${Reset}:
    executes a manual backup
  - ${Green}check${Reset}:
    checks if the backup source is intact
"""
