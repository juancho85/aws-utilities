#!/usr/bin/env bash

################################################
# HELPER METHODS
################################################

# Coloring output
export RED='\033[0;31m'
export ORANGE='\033[0;33m'
export GREEN='\033[0;32m'
export LGRAY='\033[0;0;37m'
export NC='\033[0m' # No Color

print_message() {
    MESSAGE=${1}
    printf "\n${GREEN}${MESSAGE}${NC}\n"
}

print_error() {
    MESSAGE=${1}
    printf "\n${RED}${MESSAGE}${NC}\n"
}

################################################
# MANAGING PARAMETERS
################################################

while [[ $# -ge 1 ]]
do
    key="$1"
    case $key in

        -e|--environment-file)
        ENV_FILE="$2"
        ;;

        -f|--function_name)
        FUNCTION="$2"
        ;;

        *)
            # unknown option
        ;;
    esac

    shift # past argument or value
done

################################################
# PRECONDITIONS
################################################

# Required variables
REQUIRED_VAR=( "ENV_FILE" "FUNCTION" )

for REQUIRED in "${REQUIRED_VAR[@]}"
do
    if [ -z "${!REQUIRED}" ]; then
        print_error "${REQUIRED} is required to launch the script"
        MISSING_PARAMETER=true;
    fi
done



################################################
# Tars, gzips and upload to S3
################################################

upload() {
    for i in $(find $SOURCE_DIRS  -maxdepth 0 -type d); do
         print_message "Uploading ${i}"
         if [ -n "$AWS_PROFILE" ]; then
            tar -cP ${i} | gzip -9 | aws s3 cp - s3://${BUCKET}/${TARGET_BASE_DIR}/${i}.tar.gz --profile $AWS_PROFILE
        else
            tar -cP ${i} | gzip -9 | aws s3 cp - s3://${BUCKET}/${TARGET_BASE_DIR}/${i}.tar.gz
        fi
        print_message "Finished with ${i}"
    done
}

################################################
# Downloads from S3
################################################

download() {
    for i in $SOURCE_DIRS; do
        print_message "Downloading ${i}.tar.gz"
        if [ -n "$AWS_PROFILE" ]; then
            aws s3 cp s3://${BUCKET}/${TARGET_BASE_DIR}/${i}.tar.gz ${i}.tar.gz --profile $AWS_PROFILE
        else
            aws s3 cp s3://${BUCKET}/${TARGET_BASE_DIR}/${i}.tar.gz ${i}.tar.gz
        fi

        print_message "Finished with ${i}.tar.gz"
    done
}

################################################
# Extracts files
################################################

extract() {
    for i in $SOURCE_DIRS; do
        print_message "Extracting ${i}.tar.gz"
        tar xvfz ${i}.tar.gz
        print_message "Finished with ${i}.tar.gz"
    done
}

################################################
# Gets golder sizes
################################################

sizes() {
    print_message "Getting file sizes"
    for i in $SOURCE_DIRS; do
        du -sh  ${i}
    done
    print_message "Done getting file sizes"
}


################################################
# FUNCTION EXECUTION
################################################


if [ ! -z "${ENV_FILE}" ]; then
    if [ ! -f "${ENV_FILE}" ]; then
        echo "${ENV_FILE} do not exist\n"
        exit 2
    else
        source $ENV_FILE
        print_message "executing function $FUNCTION"
        eval $FUNCTION
    fi
fi



