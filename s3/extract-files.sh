#!/usr/bin/env bash
source ./env/env.sh
for i in $SOURCE_DIRS; do
    echo "Extracting ${i}.tar.gz"
    tar xvfz ${i}.tar.gz
    echo "Finished with ${i}.tar.gz"
done