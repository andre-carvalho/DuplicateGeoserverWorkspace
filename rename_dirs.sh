#!/bin/bash


PATTERNS=("amsh:cerh" "AMSh29:CES29" "amz_:cer_" "csAmz_:csCer_")

for PATTERN in ${PATTERNS[@]}
do
    search=$(echo ${PATTERN}| cut -d':' -f1)
    replace=$(echo ${PATTERN}| cut -d':' -f2)

    for DIR_NAME in `find $INPUT_DIR/* -type d`
    do
        ND=$(echo ${DIR_NAME} | sed -e "s/${search}/${replace}/g")
        if [[ ! "${DIR_NAME}" = "${ND}" ]];
        then
            mv ${DIR_NAME} ${ND}
            # change the input path referency
            INPUT_DIR=$(echo ${INPUT_DIR} | sed -e "s/${search}/${replace}/g")
            export INPUT_DIR
        else
            echo "unchange dir ${DIR_NAME}"
        fi;
    done
done
