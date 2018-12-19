let serialNumber = 0;
const fs = require('fs');
let userData = fs.readFileSync('./.report','utf8');

const repeat = function (character,times) { 
  return new Array(times).fill(character).join('');
}

userData = userData.split('\n');
userData.pop();
let box = userData.map(x=>x.split('|'))

const justify = function(text,length) {
  let line = '';
  let fromLeft = Math.floor((length - text.length)/2);
  let toRight = Math.ceil((length - text.length)/2);
  line = line + repeat(" ",fromLeft);
  line = line + text;
  line = line + repeat(" ",toRight);
  return line;
}

const printHead = function () {
  console.log();
  console.log(generateLine());
  let head  = '|';
  head = head + justify("S.No.",10) + '|';
  head = head + justify("User Name",30) + '|';
  head = head + justify("Total Commits",15) + '|';
  head = head + justify("Last Commit",25) + '|';
  head = head + justify("Pass %",10) + '|';
  head = head + justify("Pending Tests",15) + '|';
  head = head + justify("Coverage",15) + '|';
  console.log(head); 
  console.log(generateLine());
}

const generateLine = function () {
  return repeat('-',128);
}

const generateReport = function (userName, totalCommits, lastCommit,passingAndTotalTests,pending,coverage) {
  let log = '|';
  serialNumber++;
  log = log + justify(serialNumber.toString(),10) + '|' ;
  log = log + justify(userName.toString(),30) + '|';
  log = log + justify(totalCommits.toString(),15) + '|';
  log = log + justify(lastCommit.toString(),25) + '|';
  log = log + justify(passingAndTotalTests.toString(),10) + '|';
  log = log + justify(pending.toString(),15) + '|';
  log = log + justify(coverage.toString(),15) + '|';
  console.log(log);
  console.log(generateLine());
}
printHead();
box.map(x=>generateReport.apply(null,x));
