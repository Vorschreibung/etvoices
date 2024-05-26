#!/usr/bin/env bash
#
# REQUIRES: piper-tts (e.g. from AUR/pip) ffmpeg mpv
#
set -eo pipefail

team=$1
shift || { echo "> pass team (axis/allies)" >&2; exit 1; }

message=$1
shift || { echo "> pass message" >&2; exit 1; }


{ echo "$message" | piper-tts -m "./model-${team}.onnx" --output_file ./tmp.wav; } && ffmpeg -i ./tmp.wav -y ./tmp.ogg && mpv ./tmp.wav
