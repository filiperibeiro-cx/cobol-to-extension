#!/bin/bash


# Configurations
# ---------------------------------------------------------------------

# Source code folder path
SRC_DIR="SAMPLE/"
# Source code output folder
SRC_OUTPUT="OUT-SAMPLE/"
# CxServer
CX_SERVER="http://localhost"
# CxUser
CX_USER=""
# CxPassword
CX_PASSWORD=""
# Team/Project name
CX_PROJECT_NAME="CxServer/MYPROJECTV1"


# ---------------------------------------------------------------------

# Cobol main extension
COBOL_EXTENSION="cob"
# Count files
COUNTER=0

# ---------------------------------------------------------------------

echo "Starting to analyze the source code..."
ALL_FILES=$(grep -rle '\s*IDENTIFICATION DIVISION.\s*' ${SRC_DIR}) 

for file in ${ALL_FILES[@]}; do
  new_file=${SRC_OUTPUT}${file}
  mkdir -p $(dirname ${new_file})
  cp $file $new_file.$COBOL_EXTENSION
  (( COUNTER++ ))

  if [ $(($COUNTER % 10)) == "0" ] ; then
    echo "..." $COUNTER "files..."
  fi
done
echo "Finish the source code analysis."
echo "Total files: "$COUNTER

# ---------------------------------------------------------------------



exit
