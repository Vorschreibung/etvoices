#!/usr/bin/env bash
set -eo pipefail
die() {
    printf '%b\n' "$1" >&2
    exit "${2:-1}"
}

# cd to parent dir of current script
cd "$(dirname "${BASH_SOURCE[0]}")"

cleanup_tmpfile() { rm -f "$tmpfile"; }
download_if_not_exist() {
    if [[ ! -e "$1" ]]; then
        tmpfile=$(TMPDIR="$PWD" mktemp)
        trap 'cleanup_tmpfile' EXIT INT

        ( set -x; curl --fail --retry 3 -C - -L -o "$tmpfile" "$2"; )

        mv "$tmpfile" "$1"
        trap '' EXIT INT
    fi
}

if [[ -z "$1" ]]; then
    die "> pass a file to run inside container env"
fi
file=$1
shift


# download lessac medium checkpoint
mkdir -p checkpoint-en-us
download_if_not_exist "./checkpoint-en-us/epoch=2164-step=1355540.ckpt" \
    "https://huggingface.co/datasets/rhasspy/piper-checkpoints/resolve/main/en/en_US/lessac/medium/epoch%3D2164-step%3D1355540.ckpt?download=true"
download_if_not_exist "./checkpoint-en-us/config.json" \
    "https://huggingface.co/datasets/rhasspy/piper-checkpoints/resolve/main/en/en_US/lessac/medium/config.json?download=true"


img=etvoices-train-model

# build container if necessary
sha256=$(sha256sum piper-env.Containerfile)
sha256file=.piper-env.Containerfile.sha256sum
if [[ ! -e "$sha256file" ]] || [[ "$(cat "$sha256file")" != "$sha256" ]]; then
    buildah build --layers --tag "$img" ./piper-env.Containerfile
    echo "$sha256" > "$sha256file"
fi


# run container
tmpfile=$(TMPDIR="$PWD" mktemp)
trap 'cleanup_tmpfile' EXIT INT

{
cat <<EOF
#!/usr/bin/env bash
set -eo pipefail
# shellcheck disable=SC1091
source "/usr/src/piper/src/python/.venv/bin/activate"

bash -l "$file" "\$@"
EOF
} > "$tmpfile"

tmpfile_rel=$(basename -- "$tmpfile")

# set -x
podman run \
    --rm --gpus all --env-host -v "$PWD:/opt/pwd" -it \
    --workdir "/opt/pwd" \
    --entrypoint bash "$img" -l "$tmpfile_rel" "$@"
