#!/bin/bash


# Configurations
# -------------------------------------------------------------------------------------------- #

# Source code folder path
SRC_DIR="MySrcProject/"
# Source code output folder
SRC_OUTPUT="OUT-MySrcProjectOUT/"
# CxServer
CX_SERVER="http://localhost"
# CxUser
CX_USER=""
# CxPassword
CX_PASSWORD=""
# Team/Project name
CX_PROJECT_NAME="CxServer/MYPROJECTV1"

# -------------------------------------------------------------------------------------------- #

# Cobol main extension
COBOL_EXTENSION="cob"
# Cobol copybook extension 
COBOL_COPYBOOK_EXTENSION="cpy"

# -------------------------------------------------------------------------------------------- #

# Count files
COUNTER=0
# Array to store all copybooks found on cobol files
COPYBOOK_FILES=()

echo "Starting to analyze the source code..."
ALL_FILES=$(grep -rle '\s*IDENTIFICATION DIVISION.\s*' ${SRC_DIR}) 


for file in ${ALL_FILES[@]}; do
  new_file=${SRC_OUTPUT}${file}
  mkdir -p $(dirname ${new_file})
  cp $file $new_file.$COBOL_EXTENSION

  # Check if there are any copybook on the file
  copybooks=$(grep -Po 'COPY\s*\K[^.]*' ${file})
  COPYBOOK_FILES+=(${copybooks[@]})
  
  (( COUNTER++ ))

  if [ $(($COUNTER % 10)) == "0" ] ; then
    echo "..." $COUNTER "files..."
  fi
done


# Sort elements and remove the duplicates
SORTED_UNIQUE_COPYBOOKS=($(echo "${COPYBOOK_FILES[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

for cb in ${SORTED_UNIQUE_COPYBOOKS[@]}; do 
  # Find copybook file
  FIND_COPYBOOKS=$(find ${SRC_DIR} -type f -name *${cb})
  # Copy each file found
  for fcb in ${FIND_COPYBOOKS[@]}; do
    new_copybook_file=${SRC_OUTPUT}${fcb}
    mkdir -p $(dirname ${new_copybook_file})
    cp $fcb $new_copybook_file.$COBOL_COPYBOOK_EXTENSION

    (( COUNTER++ ))

    if [ $(($COUNTER % 10)) == "0" ] ; then
      echo "..." $COUNTER "files..."
    fi
  done
done

echo "Finish the source code analysis."
echo "Total files: "$COUNTER

# -------------------------------------------------------------------------------------------- #

echo "Start running CLI..."
# Trigger a new SAST scan 
./CxConsolePlugin-1.1.21/runCxConsole.sh Scan -v -ProjectName ${CX_PROJECT_NAME} -CxServer ${CX_SERVER} -CxUser ${CX_USER} -CxPassword ${CX_PASSWORD} -LocationType folder -LocationPath "../"${SRC_OUTPUT} -preset "Checkmarx Default" -ForceScan 
echo "CLI scan finish..."
 
echo "Removing folder..."
# Remove Source code output folder
rm -drf ${SRC_OUTPUT}

echo "Done"

# -------------------------------------------------------------------------------------------- #

exit