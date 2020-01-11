#!/usr/bin/env bash

set -o errexit
set -o nounset
log() { printf '\033[1;34m*** %s\033[0m\n' "$1"; }

ldcFlags=(-dip1000 -O3 -J "$PWD")
mkdir --parents build/nilcons/{etc,target/development,test,www}

log 'build/nilcons/idl.d'
src/idl/idlc > build/nilcons/idl.d

log 'build/nilcons/test/unit'
ldc2 "${ldcFlags[@]}" -unittest \
    $(find src/nilcons -name '*.d') build/nilcons/idl.d \
    -of build/nilcons/test/unit

log 'build/nilcons/serveApi'
ldc2 "${ldcFlags[@]}" -d-version=nilconsServeApi \
    $(find src/nilcons -name '*.d') build/nilcons/idl.d \
    -of build/nilcons/serveApi

log 'build/nilcons/www/serveApi'
ln --force --relative --symbolic \
    build/nilcons/serveApi \
    build/nilcons/www/serveApi

log 'build/nilcons/etc/lighttpd.conf'
cp config/nilcons/lighttpd.conf build/nilcons/etc/lighttpd.conf

log 'build/nilcons/target/development/Procfile'
{
    echo "lighttpd: $(which lighttpd) -D -f build/nilcons/etc/lighttpd.conf"
} > 'build/nilcons/target/development/Procfile'

log 'build/nilcons/target/development/hivemind'
{
    echo "#!$(which bash)"
    echo "exec $(which hivemind) --root \$PWD \
              build/nilcons/target/development/Procfile"
} > 'build/nilcons/target/development/hivemind'
chmod +x build/nilcons/target/development/hivemind
