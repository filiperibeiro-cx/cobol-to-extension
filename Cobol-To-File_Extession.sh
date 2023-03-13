#!/bin/bash


# Configurations
# -------------------------------------------------------------------------------------------- #

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
ALL_FILES=$(grep -rlE '\s*IDENTIFICATION DIVISION.\s*|\s*ID DIVISION.\s*' ${SRC_DIR}) 

for file in ${ALL_FILES[@]}; do
  new_file=${SRC_OUTPUT}${file}
  mkdir -p $(dirname ${new_file})
  cp $file $new_file.$COBOL_EXTENSION

  # Check if there are any copybook on the file
  copybooks=$(grep -Po 'COPY\s*\K[^.]*' ${file})
  COPYBOOK_FILES+=(${copybooks[@]})
  
  (( COUNTER++ ))

  if [ $(($COUNTER % 50)) == "0" ] ; then
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
    # cobol (cob) file already exists 
    if  test -f "${SRC_OUTPUT}${fcb}.$COBOL_EXTENSION"; then :
    else
      new_copybook_file=${SRC_OUTPUT}${fcb}
      # check if the copybook file already exists 
      if  test -f "$new_copybook_file.$COBOL_COPYBOOK_EXTENSION"; then :
      else
        mkdir -p $(dirname ${new_copybook_file})
        cp $fcb $new_copybook_file.$COBOL_COPYBOOK_EXTENSION
        (( COUNTER++ ))
      fi
    fi
  done
  

  if [ $(($COUNTER % 50)) == "0" ] ; then
    echo "..." $COUNTER "files..."
  fi
done

echo "Finish the source code analysis."
echo "Total files: "$COUNTER

# -------------------------------------------------------------------------------------------- #


# -------------------------------------------------------------------------------------------- #

exit