# Selfhost stack

A single docker-composem file to selfhost a bunch of services locally in a home network.

## Guidelines

### Docker compose

- Networks should be named after the service providing something to other services
  - e.g. Name the network `sab` for exposing sab to other services like radarr and sonarr
