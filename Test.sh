#sam build
#sam deploy --guided 

STACK_NAME=$(grep stack_name ~/environment/api-gateway-header-based-versioning/samconfig.toml | awk -F\= '{gsub(/"/, "", $2); gsub(/ /, "", $2); print $2}')

DDB_TBL_NAME=$(aws cloudformation describe-stacks --region us-east-1 --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`DynamoDBTableName`].OutputValue' --output text) && echo $DDB_TBL_NAME

aws dynamodb scan --table-name $DDB_TBL_NAME

CF_DISTRIBUTION=$(aws cloudformation describe-stacks --region us-east-1 --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`CFDistribution`].OutputValue' --output text) && echo $CF_DISTRIBUTION

curl -i -o - --silent -X GET "https://${CF_DISTRIBUTION}/hello" --header "Accept:application/vnd.example.v1+json" && echo

curl -i -o - --silent -X GET "https://${CF_DISTRIBUTION}/hello" --header "Accept:application/vnd.example.v2+json" && echo

curl -i -o - --silent -X GET "https://${CF_DISTRIBUTION}/hello" && echo

