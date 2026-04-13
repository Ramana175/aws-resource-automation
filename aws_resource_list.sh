#!/bin/bash

###############################################################################
# Author: S.Venkata Ramana
# Version: v3.0

# Description:
# This script lists AWS resources based on service and region.
# It sends email alerts using SNS (Success / Error).
#
# Usage:
# ./aws_resource_list.sh <region> <service>
#
# Example:
# ./aws_resource_list.sh us-east-1 ec2
###############################################################################

# -------------------------------
# CONFIGURATION (ADD YOUR ARN)
# -------------------------------
SNS_TOPIC_ARN="arn:aws:sns:us-east-1:030046727889:my-alert-topic"

# -------------------------------
# CHECK INPUT ARGUMENTS
# -------------------------------
if [ $# -ne 2 ]; then
    echo "Usage: $0 <region> <service>"
    exit 1
fi

region=$1
service=$(echo "$2" | tr '[:upper:]' '[:lower:]')

# -------------------------------
# CHECK AWS CLI INSTALLED
# -------------------------------
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed."
    echo "Install using:"
    echo "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o awscliv2.zip"
    echo "unzip awscliv2.zip"
    echo "sudo ./aws/install"
    exit 1
fi

# -------------------------------
# CHECK AWS CONFIGURED
# -------------------------------
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS CLI not configured."
    echo "Run: aws configure"
    exit 1
fi

# -------------------------------
# FUNCTION: SEND SNS ALERT
# -------------------------------
send_alert() {
    message=$1
    aws sns publish \
        --topic-arn $SNS_TOPIC_ARN \
        --message "$message"
}

# -------------------------------
# RESOURCE LISTING
# -------------------------------
case $service in
    ec2)
        echo "Listing EC2 Instances in $region"
        output=$(aws ec2 describe-instances --region $region --output table)
        ;;
    rds)
        echo "Listing RDS Instances"
        output=$(aws rds describe-db-instances --region $region --output table)
        ;;
    s3)
        echo "Listing S3 Buckets"
        output=$(aws s3api list-buckets --output table)
        ;;
    cloudfront)
        echo "Listing CloudFront Distributions"
        output=$(aws cloudfront list-distributions --output table)
        ;;
    vpc)
        echo "Listing VPCs"
        output=$(aws ec2 describe-vpcs --region $region --output table)
        ;;
    iam)
        echo "Listing IAM Users"
        output=$(aws iam list-users --output table)
        ;;
    route53)
        echo "Listing Route53 Hosted Zones"
        output=$(aws route53 list-hosted-zones --output table)
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms"
        output=$(aws cloudwatch describe-alarms --region $region --output table)
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks"
        output=$(aws cloudformation describe-stacks --region $region --output table)
        ;;
    lambda)
        echo "Listing Lambda Functions"
        output=$(aws lambda list-functions --region $region --output table)
        ;;
    sns)
        echo "Listing SNS Topics"
        output=$(aws sns list-topics --region $region --output table)
        ;;
    sqs)
        echo "Listing SQS Queues"
        output=$(aws sqs list-queues --region $region --output table)
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables"
        output=$(aws dynamodb list-tables --region $region --output table)
        ;;
    ebs)
        echo "Listing EBS Volumes"
        output=$(aws ec2 describe-volumes --region $region --output table)
        ;;
    *)
        output="Invalid service"
        ;;
esac

# -------------------------------
# PRINT OUTPUT
# -------------------------------
echo "$output"

# -------------------------------
# SEND ALERT (SMART LOGIC)
# -------------------------------
if [[ "$output" == *"Invalid"* ]]; then
    send_alert "❌ ERROR: Invalid service '$service'"
else
    send_alert "✅ SUCCESS: $service executed in $region"
fi