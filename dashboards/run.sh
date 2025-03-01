#!/bin/sh
set -euo pipefail

# Generate the dashboard JSON using jsonnet
dashboard_json=$(jsonnet -J ../jb-vendor dashboard.jsonnet)

# Check if required env vars are set
if [ -n "${GRAFANA_URL:-}" ] && [ -n "${GRAFANA_API_KEY:-}" ]; then
    grafana_url="$GRAFANA_URL/api/dashboards/db"
    api_key=$GRAFANA_API_KEY

    # Wrap the dashboard JSON in another JSON object with overwrite: true
    payload=$(jq -n --argjson dash "$dashboard_json" --arg folderUid "$FOLDER_UID" '{dashboard: $dash, message: "", overwrite: true, folderUid: $folderUid}')

    echo $payload

    echo "Posting to $grafana_url"

    # Post the dashboard JSON to Grafana and capture response
    # Hide curl progress output with -s flag
    curl -X POST \
      -s \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $api_key" \
      -d "$payload" \
      "$grafana_url" | jq '.'
else
    # Just output the dashboard JSON if env vars not set
    echo "$dashboard_json"
fi