# web3_contract_generator

This package generates dart files to represent ethereum dapps and provide type safety.

You can put `.abi` files almost wherever, though I use `lib/abi/`.

Your ABIs should be **json** formatted as a list. For examples see [the test directory](https://github.com/secure-vote/web3_contract_generator/tree/5e8bef6d611c75708fae3f035a9e29d025cbc12a/web3_contract_generator/test/contracts).

There's a bug or issue with build_runner or something that means `.abi.json` files don't work atm. Sorry about that. Make sure your ABI extension is just `.abi`.

## Usage

it's pretty fresh (but seems to work fine), maybe don't rely on this for production code yet.

Add these dependencies:

* `dart pub add dartz` -- Needed for Tuple types (broadly useful, too)
* `dart pub add web3dart`
* `dart pub add -d build_runner` -- for codegen
* `dart pub add -d web3_contract_generator` -- Dev dependency
* `dart pub add web3_contract` -- support lib for generated code

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
