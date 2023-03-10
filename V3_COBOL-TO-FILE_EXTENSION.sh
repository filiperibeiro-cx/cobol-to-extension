#!/bin/bash

timestamp() {
  date +"%T" # current time
}

# Source code folder path
SRC_DIR="SAMPLE/"
# Source code output folder
SRC_OUTPUT="OUT-SAMPLE/"
# cobol main extension
COBOL_EXTENSION="cob"
COBOL_COPYBOOK_EXTENSION="cpy"
# Count files
COUNTER=0

# ---------------------------------------------------------------------
COPYBOOK_FILES=()

timestamp

ALL_FILES=$(grep -rle '\s*IDENTIFICATION DIVISION.\s*' ${SRC_DIR}) 

timestamp

for file in ${ALL_FILES[@]}; do
  new_file=${SRC_OUTPUT}${file}
  mkdir -p $(dirname ${new_file})
  cp $file $new_file.$COBOL_EXTENSION

  # Check if there are any copybook on the file
  #copybooks=$(grep -oe 'COPY\s*[a-zA-Z0-9_-]*' ${file})
  copybooks=$(grep -Po 'COPY\s*\K[^.]*' ${file})
  COPYBOOK_FILES+=(${copybooks[@]})
  
  #echo ${copybooks[@]}
  #echo "----"


  (( COUNTER++ ))

  if [ $(($COUNTER % 10)) == "0" ] ; then
    echo "..."$COUNTER "files..."
  fi

done

timestamp

# Order copybooks and remove duplacated
SORTED_UNIQUE_COPYBOOKS=($(echo "${COPYBOOK_FILES[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

for cb in ${SORTED_UNIQUE_COPYBOOKS[@]}; do
  echo ${cb}
done

#echo ${COPYBOOK_FILES[@]}
# echo "Total files: "$COUNTER
timestamp

exit

# ---------------------------------------------------------------------