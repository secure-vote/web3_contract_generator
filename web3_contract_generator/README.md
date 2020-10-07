# web3_contract_generator

This package generates dart files to represent ethereum dapps and provide type safety.

## Usage

it's pretty fresh, maybe don't rely on this for production code yet.

Add these dependencies:

* `dartz` -- Needed for Tuple types (broadly useful, too)
* `web3dart`
* `web3_contract_generator` -- Dev dependency
* `web3_contract` -- Dependency

Then run: `pub run build_runner build`

### Options

You can customise which files are used for generation (or manually add the build step, etc) in your build.yaml file:

```
targets:
    $default:
        builders:
            web3_contract_generator|web3_gen:
                generate_for:
                    include:
                    - "**/*.abi"
                    - "**/*.abi.json"
```

## Generated Code

Here's a sample of the code generated:

```dart
class SVIndexContract {
  final ContractAbi $abi = ContractAbi.fromJson(SVINDEX_ABI, "SVIndex");
  EthereumAddress $addr;
  DeployedContract $contract;
  Web3Client $client;
  SVIndexContract(String address, this.$client) {
    $addr = EthereumAddress.fromHex(address);
    $contract = DeployedContract($abi, $addr);
  }

  Future<String> dDeprecateCategory(Uint8List democHash, BigInt catId,
      Wallet wallet, TransactionNotPayable tx) async {
    var _f = $contract.function("dDeprecateCategory");
    var _params = _f.encodeCall(<dynamic>[democHash, catId]);
    var finalized = tx.finalize(
        data: _params,
        from: await wallet.privateKey.extractAddress(),
        to: $contract.address);
    var txid = await $client.sendTransaction(wallet.privateKey, finalized,
        fetchChainIdFromNetworkId: true);
    return txid;
  }

  Future<BigInt> getVersion({EthereumAddress from}) async {
    var _f = $contract.function("getVersion");
    var _params = <dynamic>[];
    var result = await $client.call(
        sender: _addrOrDefault(from),
        contract: $contract,
        function: _f,
        params: _params,
        atBlock: BlockNum.current());
    return result[0] as BigInt;
  }

  Future<EthereumAddress> getBBFarm(BigInt bbFarmId,
      {EthereumAddress from}) async {
    var _f = $contract.function("getBBFarm");
    var _params = <dynamic>[bbFarmId];
    var result = await $client.call(
        sender: _addrOrDefault(from),
        contract: $contract,
        function: _f,
        params: _params,
        atBlock: BlockNum.current());
    return result[0] as EthereumAddress;
  }

  Future<String> setOwner(
      EthereumAddress newOwner, Wallet wallet, TransactionNotPayable tx) async {
    var _f = $contract.function("setOwner");
    var _params = _f.encodeCall(<dynamic>[newOwner]);
    var finalized = tx.finalize(
        data: _params,
        from: await wallet.privateKey.extractAddress(),
        to: $contract.address);
    var txid = await $client.sendTransaction(wallet.privateKey, finalized,
        fetchChainIdFromNetworkId: true);
    return txid;
  }

  Future<String> dDeployBallot(
      Uint8List democHash,
      Uint8List specHash,
      Uint8List extraData,
      BigInt packed,
      Wallet wallet,
      TransactionPayable tx) async {
    var _f = $contract.function("dDeployBallot");
    var _params =
        _f.encodeCall(<dynamic>[democHash, specHash, extraData, packed]);
    var finalized = tx.finalize(
        data: _params,
        from: await wallet.privateKey.extractAddress(),
        to: $contract.address);
    var txid = await $client.sendTransaction(wallet.privateKey, finalized,
        fetchChainIdFromNetworkId: true);
    return txid;
  }
}
```
