#!/bin/sh

# create backup filename
BACKUP_FILE="bitwardenrs_$(date "+%F-%H%M%S")"

# use sqlite3 to create backup (avoids corruption if db write in progress)
sqlite3 /data/db.sqlite3 ".backup '/tmp/db.sqlite3'"

sqlite3 /data/db.sqlite3 ".backup '/tmp/db-$(date '+%Y%m%d-%H%M').sqlite3'"

# tar up backup and encrypt with openssl and encryption key
tar -czf /tmp/${BACKUP_FILE}.tar.gz /data/attachments /data/sends /data/rsa_key*

# upload encrypted tar to dropbox
/dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE}.tar.gz /${BACKUP_FILE}.tar.gz

# cleanup tmp folder
rm -rf /tmp/*

# delete older backups if variable is set & greater than 0
if [ ! -z $DELETE_AFTER ] && [ $DELETE_AFTER -gt 0 ]
then
  /deleteold.sh
fi
