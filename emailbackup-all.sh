#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"
EMAIL="ops@bettermentsecurities.com yuriy@betterment.com"
STATUS_FILE=".backup_status"
BACKEDUP_LOG=()
IN=$(cat $SCRIPTDIR/$STATUS_FILE)
PREVIOUS_LOG=(${IN// / })
PREVIOUS_MOD_DATE=$(date -r $SCRIPTDIR/$STATUS_FILE)
PREVIOUS_LOG_SIZE=${#PREVIOUS_LOG[@]} 
COUNTER=0

echo "Previously backed up accounts: ${PREVIOUS_LOG[*]} on $PREVIOUS_MOD_DATE"

shopt -s nullglob
for f in $SCRIPTDIR/*.cfg
do
        echo "Processing email account: $f"
        filename=$(basename "$f")
        extension="${filename##*.}"
        filename="${filename%.*}"
        $SCRIPTDIR/emailbackup.sh $filename

        BACKEDUPLOG[$COUNTER]=$filename
        let COUNTER=COUNTER+1
        echo "done..."
done

echo "Backed up $COUNTER Accounts"
echo ${BACKEDUPLOG[*]} > $SCRIPTDIR/$STATUS_FILE

if [ $COUNTER -lt $PREVIOUS_LOG_SIZE ]
then
        # Email ops
        echo "Backed up Email Accounts count changed from $PREVIOUS_LOG_SIZE to $COUNTER. Sending email to: $EMAIL"
        echo “$PREVIOUS_LOG_SIZE Accounts backed up on $PREVIOUS_MOD_DATE: $IN. $COUNTER Accounts backed up now: ${BACKEDUPLOG[*]}. Potential password changes detected. Please investigate” | mail -s "[BUMI] Backed up Email Accounts count changed from ${PREVIOUS_LOG_SIZE} to ${COUNTER}" $EMAIL
fi
