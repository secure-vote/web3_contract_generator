#!/usr/bin/env bash

mv build{,.main}.yaml
cp build{.json,}.yaml
/mnt/c/tools/dart-sdk/bin/pub run build_runner build
cp build{.main,}.yaml
