import 'dart:typed_data';
import 'dart:async';
import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';

final Logger _log = Logger('web3_contract_generator.helpers');

class WithZeroAddr {
  static EthereumAddress zeroAddr =
      EthereumAddress(Uint8List(20)..fillRange(0, 20, 0));

  const WithZeroAddr();

  static EthereumAddress addrOrDefault(EthereumAddress nullableAddr) {
    return nullableAddr ?? zeroAddr;
  }
}

final EthereumAddress zeroAddr =
    EthereumAddress(Uint8List(20)..fillRange(0, 20, 0));
EthereumAddress addrOrDefault(EthereumAddress nullableAddr) =>
    nullableAddr ?? zeroAddr;

Future<T> waitFor<T>(Future<T> Function() fut_gen,
    {Duration timeout = const Duration(milliseconds: 10 * 1000),
    num delta = 0.1}) async {
  return await _waitFor(fut_gen, timeout: timeout);
}

Future<T> _waitFor<T>(Future<T> Function() fut_gen,
    {Duration timeout,
    bool warnedAt5s = false,
    Duration deltaT = const Duration(milliseconds: 10)}) async {
  num startTimestamp = DateTime.now().millisecondsSinceEpoch;
  num timeoutMs = timeout.inMilliseconds;
  T res;
  while (DateTime.now().millisecondsSinceEpoch < startTimestamp + timeoutMs) {
    res = await fut_gen();
    if (res != null) return res;
    if (!warnedAt5s &&
        startTimestamp - DateTime.now().millisecondsSinceEpoch < 5000) {
      _log.warning(
          'waitFor will only wait for another 5s. fut_gen: ${fut_gen.runtimeType.toString()}');
      warnedAt5s = true;
    }
    await Future<void>.delayed(deltaT);
  }
  throw TimeoutException(
      'Future producing ${T.toString()} did not return a non-null result after ${timeout} seconds.');
}

List<Tuple2<S, T>> zip<S, T>(Iterable<S> ss, Iterable<T> ts) {
  if (ss.isEmpty || ts.isEmpty) return [];
  return [Tuple2(ss.first, ts.first), ...(zip(ss.skip(1), ts.skip(1)))];
}

class CountForever extends Iterable<int> {
  int startingNumber;
  CountForever({this.startingNumber = 0});

  @override
  Iterator<int> get iterator => CountIterator(startingNumber);
}

class CountIterator extends Iterator<int> {
  CountIterator(this.current);

  @override
  int current;

  @override
  bool moveNext() {
    current++;
    return true;
  }
}
