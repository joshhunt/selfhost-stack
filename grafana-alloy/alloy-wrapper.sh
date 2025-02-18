#!/usr/bin/env sh
source "/opt/homebrew/etc/alloy/config.env"

/opt/homebrew/opt/alloy/bin/alloy \
    run /Users/josh/selfhost-stack/grafana-alloy/config \
    --server.http.listen-addr=0.0.0.0:12345 \
    --storage.path=/opt/homebrew/var/lib/alloy/data