#!/bin/sh
while [ true ]
do
    ./getCommitDetails.sh 
    echo "Done"
    sleep 900
    ./upload.sh
done
