#!./piper-env.bash
# shellcheck disable=SC2239
set -eo pipefail

team=$1
shift || { echo "> pass team (axis/allies)" >&2; exit 1; }


python3 -m piper_train.export_onnx \
    "${PWD}/dataset-${team}/lightning_logs/version_0/checkpoints/"*.ckpt \
    "${PWD}/model-${team}.onnx"

cp "${PWD}/dataset-${team}/config.json" \
   "${PWD}/model-${team}.onnx.json"
