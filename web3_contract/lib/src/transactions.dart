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
