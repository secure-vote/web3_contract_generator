import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:web3_contract_generator/generator.dart';
import 'package:test/test.dart';
import 'package:web3dart/credentials.dart';

final FILES_TO_TEST = <String>[
  'empty',
  'SvEnsIface',
  'SVIndex',
  'SVIndexBackend',
  'SVPayments',
].map((fn) => p.joinAll(['test', 'contracts', fn]));

void main() async {
  final sources = Map<String, String>.fromEntries(
      FILES_TO_TEST.map((fn) => MapEntry(fn, readFile('${fn}.abi'))));

  final outputs = Map.fromEntries(
      FILES_TO_TEST.map((fn) => MapEntry(fn, readFile('${fn}.w3.dart'))));

  for (var k in sources.keys) {
    test('web3 generator handles ${k}', () async {
      expect(genWholeW3ContractFile(sources[k], p.split('${k}.abi').last),
          outputs[k]);
    });
  }
}

String readFile(String path) {
  return File(path).readAsStringSync();
}
