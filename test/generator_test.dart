import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen_test/source_gen_test.dart';
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
  initializeBuildLogTracking();

  /*
  final readers = await Future.forEach<String>(
      FILES_TO_TEST,
      (fn) => initializeLibraryReaderForDirectory(
          p.join('test', 'contracts'), '${fn}.abi')) as List<LibraryReader>;

  for (var reader in readers) {
    print('reader.element: ${reader.element}');
    print(reader);
    print(reader.allElements);
    print(reader.findType('abi'));
    await testBuilderOnFile(
        reader, Web3ContractGenerator(nonNullableEnabled: false));
  }
  */

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

const _pkgName = 'web3';

String readFile(String path) {
  return File(path).readAsStringSync();
}

Future<void> testBuilderOnFile(LibraryReader reader, Builder generator) async {}
