#!/usr/bin/env bash
source ./env/env.sh
for i in $SOURCE_DIRS; do
    tar xvfz ${i}.tar.gz
done