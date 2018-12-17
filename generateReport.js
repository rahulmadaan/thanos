let serialNumber = 0;
const fs = require('fs');
let userData = fs.readFileSync('./.report','utf8');

userData = userData.split('\n');
userData.pop();
let box = userData.map(x=>x.split('|'))

const justify = function(text,length) {
  let line = '';
  let fromLeft = Math.floor((length - text.length)/2);
  let toRight= Math.ceil((length - text.length)/2);
  line = line +repeat(" ",fromLeft);
  line = line + text;
  line = line +repeat(" ",toRight);
  return line;
}

const repeat = function (character,times) { 
  return new Array(times).fill(character).join('');
}

const printHead = function () {
  console.log();
  console.log(underLine());
  let head  = '|';
  head = head +justify("Serial Number",20) + '|';
  head = head + justify("User Name",35) + '|';
  head = head + justify("Total Commits",20) + '|';
  head = head + justify("Last Commit Data",35) + '|';
  console.log(head); 
  console.log(underLine());
}

const underLine = function () {
  return repeat('-',115);
}

const testLog = function (userName, totalCommits, lastCommit) {
  let log = '|';
  serialNumber++;
  log = log + justify(serialNumber.toString(),20) + '|' ;
  log = log + justify(userName.toString(),35) + '|';
  log = log + justify(totalCommits.toString(),20) + '|';
  log = log + justify(lastCommit.toString(),35) + '|';
  console.log(log);
  console.log(underLine());
}
printHead();
box.map(x=>testLog.apply(null,x));
