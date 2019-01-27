#!/bin/bash

BACKUP_FOLDER=/tmp/backup
BACKUP_FILE=$1

RESTORE_DATE=`date +%Y_%m_%d_%H_%M`

cp  /root/.bitcoin/wallet.dat /root/.bitcoin/wallet.dat-backup-${RESTORE_DATE}

rm -rf ${BACKUP_FOLDER}
mkdir -p ${BACKUP_FOLDER}

tar -xzf ${BACKUP_FILE} -C ${BACKUP_FOLDER}/
cp ${BACKUP_FOLDER}/wallet.dat /root/.bitcoin/wallet.dat


rm -rf ${BACKUP_FOLDER}

echo Backup restored
