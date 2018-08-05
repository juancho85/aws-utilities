#!/usr/bin/env bash
source ./env/env.sh
for i in $SOURCE_DIRS; do
    aws s3 cp s3://${BUCKET}/${TARGET_BASE_DIR}/${i}.tar.gz ${i}.tar.gz --profile $AWS_PROFILE
done