#!/bin/bash

ACCESS_KEY=${ACCESS_KEY:?"ACCESS_KEY env variable is required"}
SECRET_KEY=${SECRET_KEY:?"SECRET_KEY env variable is required"}
S3_PATH=${S3_PATH:?"S3_PATH env variable is required"}
DATA_PATH=${DATA_PATH:-/data/}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
SYNC_FROM_S3=${SYNC_FROM_S3:-false}

echo "access_key=$ACCESS_KEY" >> /root/.s3cfg
echo "secret_key=$SECRET_KEY" >> /root/.s3cfg

if [[ SYNC_FROM_S3 -eq "true" ]]; then
    s3cmd sync $S3_PATH $DATA_PATH
    echo "$CRON_SCHEDULE s3cmd sync \"$S3_PATH\" \"$DATA_PATH\"" | crontab -
    exec cron -f
else
    echo "$CRON_SCHEDULE s3cmd sync \"$DATA_PATH\" \"$S3_PATH\"" | crontab -
    exec cron -f
fi
