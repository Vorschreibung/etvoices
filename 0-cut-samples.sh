#!/usr/bin/env bash
# shaves off the pickup/putaway sfx of each sample and copies them to './wav/'
#
# REQUIRES: sox
set -eo pipefail

rm -rf ./wav

while read -r path; do
    {
        inpath=$path
        outpath="${path/vo-in/wav}"

        mkdir -p "${outpath%/*}"
        echo "> ${inpath} → ${outpath}"
        sox "$inpath" "$outpath" trim 0.1 -0.3
    } < /dev/tty
done < <(find ./vo-in -name "*.wav" -not -path "*news*")

