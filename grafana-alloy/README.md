Grafana Alloy is ran on the macOS host so it can monitor it properly.

All config files from the grafana-alloy/config directory are merged and loaded.

Secrets are stored in `/opt/homebrew/etc/alloy/config.env` on the host

Common labels (kind of in order of granularity):

- host: "trevor"
- job: approx each file is one "job" - docker, integrations/macos-node, traefix, etc
- project: "selfhost-stack" for everything from the docker compose project
- service: the name of the service/app the metrics are for. It's possible for one job to scrape multiple services.
