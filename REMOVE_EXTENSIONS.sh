#!/bin/bash


# Configurations
# -------------------------------------------------------------------------------------------- #

# Source code folder path
SRC_DIR="OUT-SAMPLE/"
# Source code output folder
SRC_OUTPUT="OUT-OUT-SAMPLE/"
COUNTER=0

for file in $(find ${SRC_DIR} -type f); do
  new_file=${SRC_OUTPUT}${file%.*}
  mkdir -p $(dirname ${new_file})
  cp $file $new_file
  
  (( COUNTER++ ))
  if [ $(($COUNTER % 10)) == "0" ] ; then
    echo "..." $COUNTER "files..."
  fi
done
echo "Total files: "$COUNTER

# -------------------------------------------------------------------------------------------- #

exit