import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import './src/transactions.dart';
export './src/transactions.dart';

final EthereumAddress _zeroAddr =
    EthereumAddress(Uint8List(20)..fillRange(0, 20, 0));
EthereumAddress _addrOrDefault(EthereumAddress addr) => addr ?? _zeroAddr;

class BaseContract {
  ContractAbi $abi;
  EthereumAddress $addr;
  DeployedContract $contract;
  Web3Client $client;

  Future<T> _doCall<T>(String funcName, List<dynamic> params,
      {EthereumAddress from}) async {
    var _f = $contract.function(funcName);
    var _params = <dynamic>[];
    var result = await $client.call(
        sender: _addrOrDefault(from),
        contract: $contract,
        function: _f,
        params: _params,
        atBlock: BlockNum.current());
    return result[0] as T;
  }

  Future<String> _doPayableTx<T>(String funcName, List<dynamic> params,
      Wallet wallet, TransactionPayable tx) async {
    var _f = $contract.function(funcName);
    var _params = _f.encodeCall(params);
    var finalized = tx.finalize(
        data: _params,
        from: await wallet.privateKey.extractAddress(),
        to: $contract.address);
    var txid = await $client.sendTransaction(wallet.privateKey, finalized,
        fetchChainIdFromNetworkId: true);
    return txid;
  }

  Future<String> _doNonPayableTx(String funcName, List<dynamic> params,
      Wallet wallet, TransactionNotPayable tx) async {
    var _f = $contract.function(funcName);
    var _params = _f.encodeCall(params);
    var finalized = tx.finalize(
        data: _params,
        from: await wallet.privateKey.extractAddress(),
        to: $contract.address);
    var txid = await $client.sendTransaction(wallet.privateKey, finalized,
        fetchChainIdFromNetworkId: true);
    return txid;
  }
}
