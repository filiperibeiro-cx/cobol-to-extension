#!/bin/bash

declare regex="\s*IDENTIFICATION DIVISION.\s*"

DIR="SAMPLE/"
TEMP_DIR="OUT-SAMPLE/"
EXTENSION="cob"

COUNTER=0
for file in $(find ${DIR} -type f)
do
  file_content=$( cat "${file}")
  if [[ " $file_content " =~ $regex ]]
    then
      NEW_FILE=${TEMP_DIR}/${file}
      DIRNAME=$(dirname ${NEW_FILE})
      mkdir -p "$DIRNAME" && cp $file $NEW_FILE.$EXTENSION
      (( COUNTER++ ))
  fi
done
echo "Total Files: "$COUNTER
exit
