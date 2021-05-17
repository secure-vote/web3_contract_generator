## 0.1.5

- Update READMEs to specify file types, dependencies (moreso), and be more explicit about what formats are okay.

## 0.1.4

- Change payable txs to use a `Credentials` parameter, not `Wallet`

## 0.1.3

- Minor refactoring.
- Some docs.

## 0.1.2

- Fix half-completed separation of web3_contract_generator and web3_contract
- Fix up some lints in generated code

## 0.1.1

- Add a half decent readme
- Add samples to readme
- Clean up build.yaml situation
- Clean up dependencies
- Clean up tests

## 0.1.0

- Initial version
- things it supports or stuff it does:
  - Generating classes to represent contracts
  - Type safety on the methods
  - Populates useful types for function arguments and return types
  - Attempts code generation for all .abi and .abi.json files in the package tree (or at least `lib`)
