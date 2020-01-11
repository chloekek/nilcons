#!/usr/bin/env bash

set -o errexit
set -o nounset
log() { printf '\033[1;32m** %s\033[0m\n' "$1"; }

if ! [[ -v CI ]]; then
    1>&2 echo "$0 is not to be run outside of a CI environment."
    exit 1
fi

log 'Install Nix'
nix/install --daemon > nix/install.log 2>&1 || { cat nix/install.log; exit 1; }
export PATH=/nix/var/nix/profiles/default/bin:$PATH

log 'Build Nilcons'
nix run -ic ./build.bash

log 'Unit test Nilcons'
nix run -ic prove -v build/nilcons/test/unit
