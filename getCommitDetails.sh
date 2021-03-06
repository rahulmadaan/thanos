#! /bin/bash

url=`cat internURL.txt`
length=`cat internURL.txt | wc -l`
count=1
echo 'fetching data....'
for i in $url; do 
  cd internsRepos
  userName=`echo $i | cut -d'/' -f5`
  percentage=$(echo 'scale=2;'"$count * 100 / $length"|bc)
  echo -ne '\0015'
  echo -ne `node ../progressBar.js $length $count` $percentage '%'
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
userNames=`ls ./internsRepos`
rm -rf userData
mkdir userData
rm .report
count=1
cat header > report.html
echo ''
echo 'generating report....'
for userName in $userNames; do
  cd ./internsRepos/$userName
  git log --shortstat --date=relative >> ../../userData/$userName
  echo `nyc -r json-summary mocha --recursive --reporter xunit 2>/dev/null | head -1| cut -d" " -f4,5,7` 1> ../../.tmp
  percentage=$(echo 'scale=2;'"$count * 100 / $length"|bc)
  echo -ne '\0015'
  echo -ne `node ../../progressBar.js $length $count` $percentage '%'
  count=$((count+1))
  pendingTests=`cat ../../.tmp | grep -o "skipped.*$" | grep -o '\d\+'`
  totalTests=`cat ../../.tmp | grep -o '.*failures' | grep -o '\d\+'`
  failingTests=`cat ../../.tmp | grep -o 'failures.*skipped' | grep -o '\d\+'`
  passingTests=$((totalTests - failingTests - pendingTests))
  coveragePercentage=`cat coverage/coverage-summary.json | jq '.total.lines.pct'`
  sha=`git log --oneline | cut -d' ' -f1 | head -1`
  cd ../..
  totalCommits=`grep '^commit' ./userData/$userName | wc -l`
  lastCommit=`grep 'Date' ./userData/$userName | head -1 | cut -d' ' -f4,5,6,7 | sed "s/Date://g"` 
  
  totalInsertions=`grep -o 'changed.*.insertions' ./userData/$userName | grep -o '\d\+' | awk '{sum+=$1} END {print sum}'`
  totalDeletions=`grep -o '),.*.deletions' ./userData/$userName | grep -o '\d\+'  | awk '{sum+=$1} END {print sum}'`
  totalChanges=$((totalInsertions + totalDeletions))
  changesPerCommit=$((totalChanges / totalCommits))

  user=`echo $userName | cut -d'-' -f2-`
  echo "<td>"$pendingTests"</td>" > pending
  echo "<td>"$passingTests"/"$totalTests"</td>" > passing
  echo "<tr><td><a href='https://github.com/STEP-tw/$userName'>"$user"</a></td>" > user
if [ $coveragePercentage != 100 ]; then
  echo "<td><font color = 'red'>"$coveragePercentage"</font></td>" > coverage%
else
echo "<td>"$coveragePercentage"</td>" > coverage%
fi
  echo "<td>"$totalCommits"</td>" > total
  
  echo "<td>"$lastCommit"</td>" > last
  echo "<td><a href='https://github.com/STEP-tw/$userName/commit/$sha'>"$sha"</a></td>" > sha
  echo "<td>"$changesPerCommit"</td>" "</tr>" > changes
  
  cat user total last sha passing pending coverage% changes>> report.html
  echo $userName"|" $totalCommits"|"$lastCommit"|"$passingTests/$totalTests "|" $pendingTests "|" $coveragePercentage "|" $changesPerCommit "|" $sha>> ./.report

done; 
updateTime=`date '+%D %X'`
echo  "</table>" >> report.html      # to put last modified time after the table
echo "<marquee> This report was last modified at: "$updateTime"</marquee>" >> report.html

cat ./.report | sort -t'|' -k2nr> ./.tmp
cat ./.tmp > ./.report
rm -rf coverage
rm -rf .nyc_output
cat footer >> report.html
rm user total last passing pending coverage% changes sha
./upload.sh
