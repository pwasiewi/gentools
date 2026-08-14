#!/bin/bash
# Refreshes the scripts this repo already publishes from their canonical
# copies in ~/Claude/bin (private host tree). REFRESH-ONLY by design:
#   - a file is updated only if it already exists in usr/local/bin/ here
#     AND has a counterpart in ~/Claude/bin;
#   - nothing is ever added or deleted — new scripts are added by the
#     operator deliberately, because not everything in bin/ belongs to the
#     install toolchain this repo publishes (desktop/media/VM helpers stay
#     host-side until they earn a place here);
#   - files with no bin/ counterpart (qemu-wrapper.c, Vagrantfile.*) are
#     left untouched.
# The published state matters: 'v cfg' / 'gentoolcfg' download this repo's
# master from GitHub during fresh installs, so run this + commit + push
# after fixing any published script. The rpilinuxlab live images mirror the
# same canonical bin/ via genstage/live/tools-sync.sh.
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)/usr/local/bin
SRC="${HOME}/Claude/bin"

[[ -d ${HERE} ]] || { echo "No usr/local/bin under this repo?" >&2; exit 1; }
[[ -d ${SRC}  ]] || { echo "Canonical source missing: ${SRC}" >&2; exit 1; }

refreshed=0 skipped=0
for f in "${HERE}"/*; do
    name=$(basename "${f}")
    if [[ -f ${SRC}/${name} ]]; then
        # cp -p carries the canonical mode over — data files (Vagrantfile.*,
        # qemu-wrapper.c) must NOT be blanket-chmodded executable
        command cp -pf "${SRC}/${name}" "${f}"
        refreshed=$((refreshed + 1))
    else
        skipped=$((skipped + 1))
    fi
done
echo "gentools refreshed from bin/: ${refreshed} scripts, ${skipped} without a bin/ counterpart left as-is"
