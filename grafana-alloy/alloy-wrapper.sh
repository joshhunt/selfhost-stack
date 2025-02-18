#!/usr/bin/env bash
source "/opt/homebrew/etc/alloy/config.env"

echo "ALLOY_LOKI_URL: $ALLOY_LOKI_URL"
echo "ALLOY_LOKI_USER: $ALLOY_LOKI_USER"
echo "ALLOY_PROM_URL: $ALLOY_PROM_URL"
echo "ALLOY_PROM_USER: $ALLOY_PROM_USER"

ALLOY_LOKI_URL=$ALLOY_LOKI_URL \
ALLOY_LOKI_USER=$ALLOY_LOKI_USER \
ALLOY_PROM_URL=$ALLOY_PROM_URL \
ALLOY_PROM_USER=$ALLOY_PROM_USER \
ALLOY_GRAFANA_CLOUD_TOKEN=$ALLOY_GRAFANA_CLOUD_TOKEN \
/opt/homebrew/opt/alloy/bin/alloy \
    run /Users/josh/selfhost-stack/grafana-alloy/config \
    --server.http.listen-addr=0.0.0.0:12345 \
    --storage.path=/opt/homebrew/var/lib/alloy/data



    