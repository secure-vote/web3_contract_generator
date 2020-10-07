import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';

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
