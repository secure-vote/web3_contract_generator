import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';

/// A partial transaction where the value is always 0. The user can optionally specify maxGas, gasPrice, and nonce.
class TransactionNotPayable {
  int maxGas;
  BigInt gasPrice;
  int nonce;
  TransactionNotPayable({this.maxGas = 7000000, this.gasPrice, this.nonce});

  Transaction finalize(
          {@required Uint8List data,
          @required EthereumAddress from,
          @required EthereumAddress to}) =>
      Transaction(
          data: data,
          from: from,
          gasPrice: EtherAmount.inWei(gasPrice ?? BigInt.one),
          maxGas: maxGas,
          to: to,
          value: EtherAmount.zero());
}

/// A partial transaction where the value is set by the user, which must be specified. The user can optionally specify maxGas, gasPrice, and nonce.
class TransactionPayable {
  int maxGas;
  BigInt gasPrice;
  int nonce;
  EtherAmount value;
  TransactionPayable(
      {this.maxGas = 7000000, this.gasPrice, this.nonce, @required this.value});

  Transaction finalize(
          {@required Uint8List data,
          @required EthereumAddress from,
          @required EthereumAddress to}) =>
      Transaction(
          data: data,
          from: from,
          gasPrice: EtherAmount.inWei(gasPrice ?? BigInt.one),
          maxGas: maxGas,
          to: to,
          value: value);
}

final duration30s = Duration(seconds: 30);

Future<TransactionReceipt> waitForTxReceipt(Web3Client web3, String txid,
    {int timeoutMs = 30000}) async {
  var timeout = Duration(milliseconds: timeoutMs);
  var start = DateTime.now();
  var txr = await web3.getTransactionReceipt(txid);
  while (txr == null) {
    if (DateTime.now().difference(start) > timeout) {
      throw TimeoutException(
          'Waiting for transaction receipt (for txid: $txid) timed out. Waited $timeout');
    }
    await Future<void>.delayed(Duration(milliseconds: 50));
    txr = await web3.getTransactionReceipt(txid);
  }
  return txr;
}
