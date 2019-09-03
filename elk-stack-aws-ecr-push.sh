STACK_NAME=ecr-push
if ! aws cloudformation describe-stacks --stack-name $STACK_NAME > /dev/null 2>&1; then
    aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://`pwd`/elk-stack-aws-ecr.json --parameters file://elk-stack-aws-ecr-parameters.json
else
    aws cloudformation update-stack --stack-name $STACK_NAME --template-body file://`pwd`/elk-stack-aws-ecr.json --parameters file://elk-stack-aws-ecr-parameters.json
fi