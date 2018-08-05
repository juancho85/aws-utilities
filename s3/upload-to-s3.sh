#!/usr/bin/env bash
source ./env/env.sh
for i in $(find $SOURCE_DIRS -type d); do
     echo "Uploading ${i}"
     tar -cP ${i} | gzip -9 | aws s3 cp - s3://${BUCKET}/${TARGET_BASE_DIR}/${i}.tar.gz --profile $AWS_PROFILE
     echo "FInished with ${i}"
done