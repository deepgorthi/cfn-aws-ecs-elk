#!/bin/bash
STACK_NAME=elk-ecs
if ! aws cloudformation describe-stacks --stack-name $STACK_NAME > /dev/null 2>&1; then
    aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://`pwd`/elk-stack-aws-ecs.json --parameters file://elk-stack-aws-ecs-parameters.json --capabilities CAPABILITY_IAM
else
    aws cloudformation update-stack --stack-name $STACK_NAME --template-body file://`pwd`/elk-stack-aws-ecs.json --parameters file://elk-stack-aws-ecs-parameters.json --capabilities CAPABILITY_IAM
fi