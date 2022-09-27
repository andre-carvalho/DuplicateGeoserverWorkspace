#!/bin/bash

# used to sum into first fraction of hash code (sum on hexadecimal operation)
hex_factor=111
FN="*"

if [[ "" = "$1" ]];then
    echo "Undefined file to search. Using * to any"
else
    FN="$1"
fi;

PATTERNS=("Workspace" "Style" "Layer" "Namespace" "FeatureType" "DataStore")

for PATTERN in ${PATTERNS[@]}
do
    echo "PATTERN="$PATTERN
    search="${PATTERN}InfoImpl-"

    for FILE_NAME in `find ${INPUT_DIR} -type f -name ${FN}.xml`
    do

        FD=$(grep -i ${search} $FILE_NAME)
        if [[ ! "${FD}" = "" ]];then
            
            # construct the replace string based on prefix of search string
            RP="${search}"
            # echo "FD=${FD}"
            P0=$(echo ${FD} | cut -d'-' -f2)
            if [[ "${P0}" = "" ]];then
                P0=$(echo ${FD} | cut -d'-' -f3)
                RP="${RP}-"
            fi;

            P1=$(echo ${P0} | cut -d':' -f1)
            P2=$(echo ${FD} | cut -d':' -f2)
            P3=$(echo ${FD} | cut -d':' -f3)
            PN1=$(printf "%x" $((0x$P1+0x$hex_factor)))
            P3=$(echo ${P3}| cut -d'<' -f1)
            RP2="${RP}${PN1}:${P2}:${P3}"
            # echo "RP2=${RP2}"
            
            SR=$(echo ${FD}| tr -d ' '| cut -d'>' -f2| cut -d'<' -f1)
            sed -i "s/${SR}/${RP2}/g" "$FILE_NAME"
        fi;
    done
done


PATTERNS=("ams-:cer-" "amsh:cerh" "amz_:cer_" "csAmz_:csCer_" "AMSh29:CES29" "AMS29:CES" "AMS2:CES" "public.deter_publish_date:deter.deter_publish_date" "_risk_indicators:_land_use" "nm_municip:nome" "NM_ESTADO:nome")

for PATTERN in ${PATTERNS[@]}
do
    echo "PATTERN="$PATTERN
    search=$(echo ${PATTERN}| cut -d':' -f1)
    replace=$(echo ${PATTERN}| cut -d':' -f2)

    # for xml files
    for FILE_NAME in `find ${INPUT_DIR} -type f -name ${FN}.xml`
    do
        sed -i "s/${search}/${replace}/g" "${FILE_NAME}"
    done
    # for sld files
    for FILE_NAME in `find ${INPUT_DIR} -type f -name ${FN}.sld`
    do
        sed -i "s/${search}/${replace}/g" "${FILE_NAME}"
    done
done