#!/bin/sh

# create backup filename
BACKUP_FILE="bitwardenrs_$(date "+%F-%H%M%S")"

# use sqlite3 to create backup (avoids corruption if db write in progress)
cd ./data

sqlite3 db.sqlite3 ".backup 'db-backup.sqlite3'"

sleep 20

# tar up backup and encrypt with openssl and encryption key
tar -czf ${BACKUP_FILE}.tar.gz attachments sends rsa_key*

cd ..
# upload encrypted tar to dropbox
/dropbox_uploader.sh -f /config/.dropbox_uploader upload /data/${BACKUP_FILE}.tar.gz /${BACKUP_FILE}.tar.gz

# cleanup tmp folder



# delete older backups if variable is set & greater than 0
if [ ! -z $DELETE_AFTER ] && [ $DELETE_AFTER -gt 0 ]
then
  /deleteold.sh
fi
