# Define variables
$remoteServer = "josh@trevor.local"    # Replace with your remote server details
$remoteRepoPath = "/path/to/remote/repo" # Replace with your remote repository path
$branch = "main"                        # Replace with your branch name if different

# Step 1: Do the git push
Write-Host "Performing git push..."
git push origin $branch
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git push failed. Exiting script."
    exit $LASTEXITCODE
}

# Step 2: SSH into the remote server and perform a git pull
$remoteCommand = @"
cd $remoteRepoPath && git pull origin $branch
"@

Write-Host "Connecting to remote server to perform git pull..."
ssh $remoteServer $remoteCommand
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git pull on remote server failed. Exiting script."
    exit $LASTEXITCODE
}

Write-Host "Git push and pull operations completed successfully."
