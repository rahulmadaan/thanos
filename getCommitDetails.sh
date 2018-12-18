#! /bin/bash

url=`cat internURL.txt`
length=`cat internURL.txt | wc -l`
count=1
for i in $url; do 
  cd internsRepos
  userName=`echo $i | cut -d'/' -f5`
  percentage=$(echo 'scale=2;'"$count * 100 / $length"|bc)
  echo -ne '\0015'
  echo -ne `node ../progressBar.js $length $count` $percentage
  count=$((count+1))
  
  if [ ! -d ${userName} ]; then
    git clone $i 1>/dev/null 2>/dev/null
  else
    cd $userName
    git pull 1>/dev/null 2>/dev/null
    cd ..
  fi
  cd ..
done;
userNames=`ls ./internsRepos | grep 'head'`
rm -rf userData
mkdir userData
rm .report
for userName in $userNames; do
  cd ./internsRepos/$userName
  git log >> ../../userData/$userName
  cd ../..

  totalCommits=`grep '^commit' ./userData/$userName | wc -l`
  lastCommit=`grep 'Date' ./userData/$userName | head -1 | cut -d'+' -f1 | sed "s/Date://g"` 
  echo $userName"|" $totalCommits"|"$lastCommit >> ./.report
done;

cat ./.report | sort -t'|' -k2nr> ./.tmp
cat ./.tmp > ./.report
rm .tmp
node generateReport.js
