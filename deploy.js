var fs = require('fs');

var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider('http://0.0.0.0:8545'));
web3.eth.defaultAccount = web3.eth.coinbase;

var solc = require('solc');
process.removeAllListeners("uncaughtException");

var source = fs.readFileSync('./LePoint.sol', 'utf8');
var compiled = solc.compile(source).contracts.LePoint;

// result keys
// [ 'assembly',
//   'bytecode',
//   'functionHashes',
//   'gasEstimates',
//   'interface', <== this is the ABI
//   'opcodes',
//   'runtimeBytecode',
//   'solidity_interface' ]

var contract = web3.eth.contract(JSON.parse(compiled.interface));
contract.new({data: compiled.bytecode, gas: 2000000}, function(err, instance) {
  if (err)
    return console.error(err);

  // Called twice. First with the transactionHash, then after the transaction has been mined.
  if (instance.address) {
    console.log('Deployed to: ' + instance.address);
    console.log('ABI: ' + compiled.interface);
  } else {
    console.log('Waiting for mining...');
  }
});
