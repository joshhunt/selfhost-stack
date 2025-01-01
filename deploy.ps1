# Define variables
$remoteServer = "josh@trevor.local"    # Replace with your remote server details
$remoteRepoPath = "/Users/josh/selfhost-stack" # Replace with your remote repository path
$branch = "main"                        # Replace with your branch name if different

# Step 1: Perform a git commit with passed arguments
Write-Host "Performing git commit with passed arguments: $($args -join ' ')"
git commit @args
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git commit failed. Exiting script."
    exit $LASTEXITCODE
}

# Step 2: Perform a git push
Write-Host "Performing git push..."
git push origin $branch
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git push failed. Exiting script."
    exit $LASTEXITCODE
}

# Step 3: SSH into the remote server and perform a git pull
$remotePullCommand = @"
cd $remoteRepoPath && git pull origin $branch
"@

Write-Host "Connecting to remote server to perform git pull..."
ssh $remoteServer $remotePullCommand
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git pull on remote server failed. Exiting script."
    exit $LASTEXITCODE
}

Write-Host "Git commit, push, and pull operations completed successfully."

# $remoteDockerCommand = @"
# cd $remoteRepoPath && /usr/local/bin/docker-compose up -d && /usr/local/bin/docker-compose logs -f
# "@

# ssh $remoteServer $remoteDockerCommand