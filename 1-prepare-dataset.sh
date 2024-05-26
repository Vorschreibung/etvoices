#!./piper-env.bash
# shellcheck disable=SC2239
#
# converts our own './dataset.yml' to what 'piper' expects and then produces a
# dataset per team to be trained later
set -eo pipefail

team=$1
shift || { echo "> pass team (axis/allies)" >&2; exit 1; }


./prepare-dataset.py "$team"

output_dir=./dataset-${team}
rm -rf "$output_dir"

python3 -m piper_train.preprocess \
    --language en-us \
    --input-dir "." \
    --output-dir "$output_dir" \
    --dataset-format ljspeech \
    --single-speaker \
    --sample-rate 22050
