#!/bin/bash
set -e
REPO_NAME=$1
ECR_URL=289503391411.dkr.ecr.us-east-1.amazonaws.com
if [ $# -ne 1 ]; then
    echo $0: usage: $0 REPO_NAME
    exit 1
fi
eval $(aws ecr get-login --region us-east-1 --no-include-email | sed 's|https://||')
docker build -t "$REPO_NAME" .
docker tag "$REPO_NAME":latest "$ECR_URL"/"$REPO_NAME":latest
docker push "$ECR_URL"/"$REPO_NAME":latest
