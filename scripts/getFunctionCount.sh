#! /bin/bash

directoryName=$1

files=`find $directoryName -type f -not -name "*.json" -not -name "*Test*" -not -name "*test*" -not -path '*test*'  -not -path '*Test*' -not -name "*.txt" -not -name "*.sh" -not -name "*.md" -not -path '*/\.*'`
# get file names in directory of any depth and excluding files ending 
# with extensions '.json', '.txt', '.sh' '.md' etc. ,dot files , test files and test directories.
touch .tmp

totalFunctions=0
 for file in $files; do
    functionNames=`grep 'function' $file | cut -d' ' -f2` 
    echo $functionNames > .tmp
    functionCount=`cat .tmp | wc -w`   
    totalFunctions=$((totalFunctions + functionCount))
    
done;
echo 'total functions are ' $totalFunctions


