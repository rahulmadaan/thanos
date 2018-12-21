let serialNumber = 0;
const fs = require('fs');
const chalk = require("chalk");
let userData = fs.readFileSync('./.report','utf8');
const pipe = chalk.blue("|");


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
  line = line + chalk.green(text);
  line = line + repeat(" ",toRight);
  return line;
}

const printHead = function () {
  console.log();
  console.log(chalk.blue(generateLine()));
  let head  = pipe;
  head = head + justify("S.No.",10) + pipe;
  head = head + justify("User Name",30) + pipe;
  head = head + justify("Total Commits",15) + pipe;
  head = head + justify("Last Commit",25) + pipe;
  head = head + justify("Pass %",10) + pipe;
  head = head + justify("Pending Tests",15) + pipe;
  head = head + justify("Coverage",15) + pipe;
  console.log(head); 
  console.log(chalk.blue(generateLine()));
}

const generateLine = function () {
  return repeat('-',128);
}

const generateReport = function (userName, totalCommits, lastCommit,passingAndTotalTests,pending,coverage) {
  let log = pipe;
  serialNumber++;
  log = log + justify(serialNumber.toString(),10) + pipe;
  log = log + justify(userName.toString(),30) + pipe;
  log = log + justify(totalCommits.toString(),15) + pipe;
  log = log + justify(lastCommit.toString(),25) + pipe;
  log = log + justify(passingAndTotalTests.toString(),10) + pipe;
  log = log + justify(pending.toString(),15) + pipe;
  log = log + justify(coverage.toString(),15) + pipe;
  console.log(log);
  console.log(chalk.blue(generateLine()));
}
printHead();
box.map(x=>generateReport.apply(null,x));
