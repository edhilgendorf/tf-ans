rsync -vaP ~/.aws/credentials ec2-user@$(terraform output -json | jq  -r '."Jenkins-Main-Node-Public-IP"."value"'):/tmp/credentials
