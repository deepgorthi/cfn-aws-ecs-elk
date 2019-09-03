#!/bin/bash

set -e
AWS_ACCOUNT_ID=XXXXXXXXXX
REPO_NAME=$1
ES_VERSION=6.5.4
AWS_DEFAULT_REGION=us-east-1
if [ $# -ne 1 ]; then
    echo $0: usage: $0 REPO_NAME
    exit 1
fi
eval $(aws ecr get-login --region $AWS_ACCOUNT_ID --no-include-email | sed 's|https://||')
#docker build -t "$REPO_NAME" .
#docker tag "$REPO_NAME":latest "$ECR_URL"/"$REPO_NAME":latest
#docker push "$ECR_URL"/"$REPO_NAME":latest
docker build --build-arg ES_VERSION=$ES_VERSION -t $REPO_NAME:$ES_VERSION .
docker tag $REPO_NAME:$ES_VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$REPO_NAME:$ES_VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$REPO_NAME:$ES_VERSION