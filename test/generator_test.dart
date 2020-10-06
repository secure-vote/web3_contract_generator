import 'dart:io';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:web3_contract_generator/generator.dart';
import 'package:test/test.dart';
import 'package:web3dart/credentials.dart';

void main() async {
  test('web3 generator handles our own content', () async {
    // var reader = await ('test', 'empty.abi');

    print('running web3 generator test');
    await testBuilder(
      Web3ContractGenerator(),
      sources,
      reader: await PackageAssetReader.currentIsolate(
          rootPackage: 'web3_contract_generator'),
      generateFor: {'**/*.abi'},
      outputs: outputs,
    );
  });
}

const _pkgName = 'web3';

final sources = Map.fromEntries([
  MapEntry('$_pkgName|test/empty.abi', readFile('test/empty.abi'))
]); // {'$_pkgName|lib/contracts/empty.abi': '[]'};

const outputs = {'$_pkgName|lib/contracts/empty.w3.dart': ''};

String readFile(String path) {
  return File(path).readAsStringSync();
}
