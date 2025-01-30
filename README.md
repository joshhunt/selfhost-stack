# Selfhost stack

A single docker-composem file to selfhost a bunch of services locally in a home network.

## Secrets

The following secrets must be configured in the $CONFIG_PATH/secrets directory:

### `cloudflare-selfhost-stack-letsencrypt-trtr-dot-co.txt`

Used in the traefik container to do the LetsEncrypt DNS challenge for a HTTPS certificate.

A Cloudflare API Token configured as per https://go-acme.github.io/lego/dns/cloudflare/#api-tokens

### `duplicati-secrets-file.json`

Used in the duplicati container to encrypt the settings database and set the UI password.

It should be a JSON file in the format of

```json
{
  "settings-key": "<encryption key>",
  "ui-password": "<ui password>"
}
```

### `grafana-alloy-token.txt`

Used in the grafana-alloy container to send logs to Grafana Cloud.

Must be an Grafana Cloud access policy token with at least "write logs" permission. It must not end with a newline `/n` character.

### `grafana-alloy-loki-url.txt`

Used in the grafana-alloy container to send logs to Grafana Cloud.

The full Loki logs ingest URL. It must not end with a newline `/n` character.

### `grafana-alloy-loki-user.txt`

Used in the grafana-alloy container to send logs to Grafana Cloud.

The full Loki logs user name/ID. It must not end with a newline `/n` character.

## Guidelines

### Docker compose

- Networks should be named after the service providing something to other services
  - e.g. Name the network `sab` for exposing sab to other services like radarr and sonarr

Hello World
