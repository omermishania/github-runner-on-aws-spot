#!/bin/bash


# Download jq for extracting the Token
yum install jq -y

# Create and move to the working directory
mkdir /actions-runner && cd /actions-runner

# Download the latest runner package
curl -o actions-runner-linux-x64-2.286.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.286.1/actions-runner-linux-x64-2.286.1.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.286.1.tar.gz

# Change the owner of the directory to ec2-user
chown ec2-user -R /actions-runner

# Get the runner's token
PAT="Your Super Secret PAT"
token=$(curl -s -XPOST -H "authorization: token $PAT" https://api.github.com/repos/<github-username>/<github-repository-name>/actions/runners/registration-token | jq -r .token)

# Create the runner and start the configuration experience
sudo -u ec2-user ./config.sh --url https://github.com/<github-username>/<github-repository-name> --token $token --name "spot-runner-$(hostname)" --unattended

# Create the runner's service
./svc.sh install

# Start the service
./svc.sh start
