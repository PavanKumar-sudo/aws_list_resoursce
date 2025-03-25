#!/bin/bash

# This is the script will list all the resource in the aws account
# Author: Pavan/devops Team
# Version: v.0.01
# Below are the services that are supported by this script:
# 1. EC2
# 2. RDS
# 3. S3
# 4. CloudFront
# 5. VPC
# 6. IAM
# 7. Route53
# 8. CloudWatch
# 9. CloudFormation
# 10. Lambda
# 11. SNS
# 12. SQS
# 13. DynamoDB
# 14. VPC
# 15. EBS
#
# The script will prompt the user to enter the AWS region and the service for which the resources need to be listed.
#
# Usage: ./aws_resource_list.sh  <aws_region> <aws_service>
# Example: ./aws_resource_list.sh us-east-1 ec2
#############################################################################

# Check if the required number of arguments are passed
if [ $# -ne 2 ]; then
    echo "Usage: ./aws_resource_list.sh  <aws_region> <aws_service>"
    echo "Example: ./aws_resource_list.sh us-east-1 ec2"
    exit 1
fi

# Assign the arguments to variables and convert the service to lowercase
aws_region=$1
aws_service=$(echo "$2" | tr '[:upper:]' '[:lower:]')

# Check if the AWS CLI is installed
# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Attempting to install AWS CLI..."

    # Check if unzip is installed
    if ! command -v unzip &> /dev/null; then
        echo "Installing unzip..."
        sudo apt-get update && sudo apt-get install -y unzip
    fi

    # Download and install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    # Verify installation
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI installation failed. Please install manually."
        exit 1
    else
        echo "AWS CLI installed successfully."
    fi
else
    echo "AWS CLI is already installed."
fi


# Check if the AWS CLI is configured
# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install the AWS CLI and try again."
    exit 1
else
    echo "AWS CLI is installed."
fi

# Check if AWS CLI is configured
if [ ! -f ~/.aws/credentials ] || [ ! -f ~/.aws/config ]; then
    echo "AWS CLI is not configured. Starting configuration..."
    
    read -p "Enter your AWS Access Key ID: " access_key
    read -p "Enter your AWS Secret Access Key: " secret_key
    read -p "Enter your Default region name (e.g., us-east-1): " default_region
    read -p "Enter your Output format (json, yaml, text): " output_format

    mkdir -p ~/.aws

    # Create credentials file
    cat > ~/.aws/credentials <<EOL
[default]
aws_access_key_id = $access_key
aws_secret_access_key = $secret_key
EOL

    # Create config file
    cat > ~/.aws/config <<EOL
[default]
region = $default_region
output = $output_format
EOL

    echo "AWS CLI configured successfully."
else
    echo "AWS CLI is already configured. Proceeding to list resources..."
fi


# List the resources based on the service
case $aws_service in
    ec2)
        echo "Listing EC2 Instances in $aws_region"
        aws ec2 describe-instances --region $aws_region
        ;;
    rds)
        echo "Listing RDS Instances in $aws_region"
        aws rds describe-db-instances --region $aws_region
        ;;
    s3)
        echo "Listing S3 Buckets in $aws_region"
        aws s3api list-buckets --region $aws_region
        ;;
    cloudfront)
        echo "Listing CloudFront Distributions in $aws_region"
        aws cloudfront list-distributions --region $aws_region
        ;;
    vpc)
        echo "Listing VPCs in $aws_region"
        aws ec2 describe-vpcs --region $aws_region
        ;;
    iam)
        echo "Listing IAM Users in $aws_region"
        aws iam list-users --region $aws_region
        ;;
    route5)
        echo "Listing Route53 Hosted Zones in $aws_region"
        aws route53 list-hosted-zones --region $aws_region
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms in $aws_region"
        aws cloudwatch describe-alarms --region $aws_region
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks in $aws_region"
        aws cloudformation describe-stacks --region $aws_region
        ;;
    lambda)
        echo "Listing Lambda Functions in $aws_region"
        aws lambda list-functions --region $aws_region
        ;;
    sns)
        echo "Listing SNS Topics in $aws_region"
        aws sns list-topics --region $aws_region
        ;;
    sqs)
        echo "Listing SQS Queues in $aws_region"
        aws sqs list-queues --region $aws_region
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables in $aws_region"
        aws dynamodb list-tables --region $aws_region
        ;;
    ebs)
        echo "Listing EBS Volumes in $aws_region"
        aws ec2 describe-volumes --region $aws_region
        ;;
    *)
        echo "Invalid service. Please enter a valid service."
        exit 1
        ;;
esac
