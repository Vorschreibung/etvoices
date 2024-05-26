# etvoices
Repository to train and use piper-tts voices from Enemy Territory samples.

# Requires
- sox
- podman
- an nvidia gpu (by default, CPU is also possible but slower, AFAIS no AMD) + https://wiki.archlinux.org/title/Podman#NVIDIA_GPUs

# Usage
1. Unpack all Enemy Territory `.pk3`s into some temporary directory.
2. Move `./sound/vo/` from this temporary directory to your `etvoices` checkout `./vo-in/`
3. Run `./0-cut-samples.sh`
4. Run `./1-prepare-dataset.sh <team>`
5. Run `./2-train-model.sh <team>`
6. Run `./3-export-model.sh <team>`
7. Run `"./4-say.sh <team> <message>"`
