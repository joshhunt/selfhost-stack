#!/bin/bash

set -ex

# Define the Grafana URL and API key
grafana_url="$GRAFANA_URL/api/dashboards/db"
api_key=$GRAFANA_API_KEY

# Generate the dashboard JSON using jsonnet
dashboard_json=$(jsonnet -J vendor dashboard.jsonnet)

# Wrap the dashboard JSON in another JSON object with overwrite: true
payload=$(jq -n --argjson dash "$dashboard_json" --arg folderUid "$FOLDER_UID" '{dashboard: $dash, message: "", overwrite: true, folderUid: $folderUid}')

echo $payload



# # Post the dashboard JSON to Grafana
curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $api_key" -d "$payload" $grafana_url