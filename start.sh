#!/bin/bash

#SEE LOCAL NOTES
ACCESS_TOKEN=$ACCESS_TOKEN
OWNER=$OWNER
REPO=$REPO
GITHUB_REPO=$GITHUB_REPO


set -x
#REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)
REG_TOKEN=$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${OWNER}/${REPO_NAME}/actions/runners/registration-token | jq .token --raw-output)

echo "REG TOKEN: ${REG_TOKEN}"
cd /home/docker/actions-runner

echo "Before config sh"
#./config.sh --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN}
#./config1.sh --url https://github.com/octo-org --token ${REG_TOKEN} --name f2h_runner
./config.sh --url ${GITHUB_REPO} --token ${REG_TOKEN} --name f2h_runner

echo "After config sh"

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM
echo 'Running run.sh'
./run.sh & wait $!