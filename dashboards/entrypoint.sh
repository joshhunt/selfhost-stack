#!/bin/sh
set -euo pipefail

cd /dashboards

jb install --jsonnetpkg-home ../jb-vendor

if [ "$#" -eq 0 ]; then
    echo "Error: Missing required argument 'build' or 'watch'"
    exit 1
fi

if [ "$1" = "build" ]; then
    exec /src/run.sh
elif [ "$1" = "watch" ]; then
    exec watchexec -r -c -- /src/run.sh
else
    echo "Error: First argument must be either 'build' or 'watch'"
    exit 1
fi

