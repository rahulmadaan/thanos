const repeat = function(length,symbol) {
    return new Array(length).fill(symbol).join('');
}
const getProgressBar = function(totalLength,numberOfHash) {
    let bar = [];
    let symbol = '#';
    bar.push(repeat(numberOfHash,symbol),repeat(totalLength - numberOfHash,'.'));
    return bar.join('');
}
//process.stdout.write(getProgressBar(+process.argv[2],+process.argv[3]));
process.stdout.write(getProgressBar(+process.argv[2],+process.argv[3]));