#!/bin/bash

# Source code folder path
SRC_DIR="SAMPLE/"
# Source code output folder
SRC_OUTPUT="OUT-SAMPLE/"
# Cobol main extension
COBOL_EXTENSION="cob"
# Count files
COUNTER=0

# ---------------------------------------------------------------------

ALL_FILES=$(grep -rle '\s*IDENTIFICATION DIVISION.\s*' ${SRC_DIR}) 

for file in ${ALL_FILES[@]}; do
  new_file=${SRC_OUTPUT}${file}
  mkdir -p $(dirname ${new_file})
  cp $file $new_file.$COBOL_EXTENSION
  (( COUNTER++ ))
done

echo "Total files: "$COUNTER
exit

# ---------------------------------------------------------------------