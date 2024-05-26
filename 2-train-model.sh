#!./piper-env.bash
# shellcheck disable=SC2239
#
# https://github.com/rhasspy/piper/blob/master/TRAINING.md
# https://ssamjh.nz/create-custom-piper-tts-voice/
#
# INFO: tweak 'max_epochs' for how long to run
# INFO: on my 3060 Ti 12000 epochs take ~9hrs - output seems decent
set -eo pipefail

team=$1
shift || { echo "> pass team (axis/allies)" >&2; exit 1; }


ckpt="./checkpoint-en-us/epoch=2164-step=1355540.ckpt"  # medium

args=(
    --dataset-dir "./dataset-${team}"
    --accelerator 'gpu'
    --devices 1
    --batch-size 32
    --validation-split 0.0
    --num-test-examples 0
    --max_epochs 12000
    --resume_from_checkpoint "$ckpt"
    --checkpoint-epochs 1
    --precision 32
)

python3 -m piper_train "${args[@]}"
