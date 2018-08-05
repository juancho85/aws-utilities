#!/usr/bin/env bash
source ./env/env.sh
for i in $SOURCE_DIRS; do
    echo "Downloading ${i}.tar.gz"
    aws s3 cp s3://${BUCKET}/${TARGET_BASE_DIR}/${i}.tar.gz ${i}.tar.gz --profile $AWS_PROFILE
    echo "Finished with ${i}.tar.gz"
done