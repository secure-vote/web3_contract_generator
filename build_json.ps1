cp build.yaml build.main.yaml
cp build.json.yaml build.yaml
pub run build_runner build
mv build.main.yaml build.yaml
