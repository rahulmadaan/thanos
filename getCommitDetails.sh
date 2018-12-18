#! /bin/bash

#url=`cat internURL.txt`
#length=`cat internURL.txt | wc -l`
#count=1
#for i in $url; do 
#  cd internsRepos
#  userName=`echo $i | cut -d'/' -f5`
#  percentage=$(echo 'scale=2;'"$count * 100 / $length"|bc)
#  echo -ne '\0015'
#  echo -ne `node ../progressBar.js $length $count` $percentage
#  count=$((count+1))
#  
#  if [ ! -d ${userName} ]; then
#    git clone $i 1>/dev/null 2>/dev/null
#  else
#    cd $userName
#    git pull 1>/dev/null 2>/dev/null
#    cd ..
#  fi
#  cd ..
#done;
userNames=`ls ./internsRepos | grep 'head'`
rm -rf userData
mkdir userData
rm .report
for userName in $userNames; do
  cd ./internsRepos/$userName
  git log >> ../../userData/$userName
  echo `mocha --recursive --reporter xunit | head -1| cut -d" " -f4,5,7` > ../../.tmp 
  pendingTests=`cat ../../.tmp | grep -o "skipped.*$" | grep -o '\d\+'`
  totalTests=`cat ../../.tmp | grep -o '.*failures' | grep -o '\d\+'`
  failingTests=`cat ../../.tmp | grep -o 'failures.*skipped' | grep -o '\d\+'`
  passingTests=$((totalTests - failingTests - pendingTests))
  cd ../..
  totalCommits=`grep '^commit' ./userData/$userName | wc -l`
  lastCommit=`grep 'Date' ./userData/$userName | head -1 | cut -d' ' -f4,5,6,7 | sed "s/Date://g"` 
  echo $userName"|" $totalCommits"|"$lastCommit"|"$passingTests/$totalTests "|" $pendingTests >> ./.report
done;

cat ./.report | sort -t'|' -k2nr> ./.tmp
cat ./.tmp > ./.report
#rm .tmp
node generateReport.js
