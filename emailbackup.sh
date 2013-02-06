#!/bin/bash

ACCOUNT=$1
if [ -z $1 ]; then
        echo "Usage: $0 (email.account.name}"
        exit -1
fi

TIMESTAMP=`date`
SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"
HOMEDIR=/home/bumi/mail/$ACCOUNT
LOGFILE=/var/log/gyb/bumi.log
MSG="$TIMESTAMP: Performing email backup for $ACCOUNT to $HOMEDIR using $SCRIPTDIR"
echo $MSG
echo $MSG >> $LOGFILE
/usr/local/bin/python $SCRIPTDIR/gyb.py --email $ACCOUNT --backup --folder $HOMEDIR --compress >>$LOGFILE 2>&1
echo "------------------" >> $LOGFILE
echo "Completed. Output logged to $LOGFILE"
