# Runbooks & common tasks

## Copy files from local filesystem to docker volume

tl;dr: Start a temporary container to mount the volume, copy the files, then stop the container.

```bash
# Start a temporary container to mount the volume
docker run -d --rm --name temp -v selfhost-stack_bazarr-config:/bazarr-root alpine tail -f /dev/null

# Copy the files (copies all files in the directory to the rool of the volume)
docker cp /Users/josh/selfhost-stack-config/bazarr/. temp:/bazarr-root

# Stop the container
docker stop temp
```

## Edit files in a volume

tl;dr:

```bash
# Start a temporary container to mount the volume
docker run -d --rm --name temp -v selfhost-stack_prowlarr-config:/volume alpine tail -f /dev/null

# Get a shell into the container
docker exec -it temp sh

# Edit the files with vi or whatever

# Stop the container
docker stop temp
```

## Restore docker volume backups

See https://offen.github.io/docker-volume-backup/how-tos/restore-volumes-from-backup.html
