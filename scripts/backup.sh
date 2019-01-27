#!/bin/bash

BACKUP_FOLDER=/tmp/backup
BACKUP_FILE=/tmp/bitcoind_wallet.tgz

rm -f ${BACKUP_FILE}
rm -rf ${BACKUP_FOLDER}
mkdir -p ${BACKUP_FOLDER}

cp /root/.bitcoin/wallet.dat ${BACKUP_FOLDER}

cd ${BACKUP_FOLDER} && tar -czf ${BACKUP_FILE} wallet.dat

cd /

rm -rf ${BACKUP_FOLDER}

echo ${BACKUP_FILE}
