# 🚀 AWS Resource Lister with SNS Alerts

![Bash](https://img.shields.io/badge/Shell-Bash-green?style=flat-square&logo=gnu-bash)
![AWS](https://img.shields.io/badge/Cloud-AWS-orange?style=flat-square&logo=amazon-aws)
![Version](https://img.shields.io/badge/Version-v3.0-blue?style=flat-square)
![Author](https://img.shields.io/badge/Author-S.Venkata%20Ramana-purple?style=flat-square)

A production-ready Bash script to **list AWS resources** across multiple services and regions, with **real-time SNS email alerts** on success or failure.

---

## 📌 Features

- ✅ Lists resources across **14 AWS services** with a single command
- ✅ Sends **SNS email alerts** — success ✅ or error ❌ — automatically
- ✅ Validates AWS CLI installation and credentials before execution
- ✅ Clean `--output table` format for easy reading
- ✅ Case-insensitive service input (ec2, EC2, Ec2 all work)

---

## 🛠️ Supported AWS Services

| Service | What it Lists |
|---|---|
| `ec2` | EC2 Instances |
| `rds` | RDS Database Instances |
| `s3` | S3 Buckets |
| `cloudfront` | CloudFront Distributions |
| `vpc` | Virtual Private Clouds |
| `iam` | IAM Users |
| `route53` | Route53 Hosted Zones |
| `cloudwatch` | CloudWatch Alarms |
| `cloudformation` | CloudFormation Stacks |
| `lambda` | Lambda Functions |
| `sns` | SNS Topics |
| `sqs` | SQS Queues |
| `dynamodb` | DynamoDB Tables |
| `ebs` | EBS Volumes |

---

## ⚙️ Prerequisites

### 1. AWS CLI Installed
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### 2. AWS CLI Configured
```bash
aws configure
# Enter: Access Key, Secret Key, Region, Output format
```

### 3. SNS Topic Created
- Go to AWS Console → SNS → Create Topic
- Subscribe your email to the topic
- Copy the **Topic ARN** and update in the script:
```bash
SNS_TOPIC_ARN="arn:aws:sns:us-east-1:YOUR_ACCOUNT_ID:YOUR_TOPIC_NAME"
```

---

## 🚀 Usage

```bash
# Give execute permission
chmod +x aws_resource_list.sh

# Run the script
./aws_resource_list.sh <region> <service>
```

### Examples

```bash
# List EC2 instances in us-east-1
./aws_resource_list.sh us-east-1 ec2

# List S3 buckets
./aws_resource_list.sh us-east-1 s3

# List Lambda functions in ap-south-1
./aws_resource_list.sh ap-south-1 lambda

# List DynamoDB tables in eu-west-1
./aws_resource_list.sh eu-west-1 dynamodb
```

---

## 📤 Sample Output

```
Listing EC2 Instances in us-east-1
-------------------------------------------------------
|                  DescribeInstances                  |
+-----------------------------------------------------+
|  InstanceId  |  State   |  Type      |  PublicIP    |
+--------------+----------+------------+--------------+
|  i-0abc123   | running  | t2.micro   | 54.x.x.x     |
+--------------+----------+------------+--------------+

✅ SNS Alert Sent: SUCCESS - ec2 executed in us-east-1
```

---

## 📧 SNS Alert Logic

| Condition | Alert Sent |
|---|---|
| Valid service executed | ✅ `SUCCESS: <service> executed in <region>` |
| Invalid service entered | ❌ `ERROR: Invalid service '<input>'` |

---

## 📁 Project Structure

```
aws-resource-lister/
│
├── aws_resource_list.sh     # Main script
└── README.md                # Documentation
```

---

## 🔐 IAM Permissions Required

Make sure your AWS IAM user/role has these permissions:

```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:Describe*",
    "rds:Describe*",
    "s3:ListBuckets",
    "cloudfront:ListDistributions",
    "iam:ListUsers",
    "route53:ListHostedZones",
    "cloudwatch:DescribeAlarms",
    "cloudformation:DescribeStacks",
    "lambda:ListFunctions",
    "sns:ListTopics",
    "sns:Publish",
    "sqs:ListQueues",
    "dynamodb:ListTables"
  ],
  "Resource": "*"
}
```

---

## 🧠 How It Works

```
Input: region + service
        ↓
Validate AWS CLI installed?
        ↓
Validate AWS credentials configured?
        ↓
Run AWS CLI command for service
        ↓
Print table output
        ↓
Send SNS alert (Success / Error)
```

---

## 👨‍💻 Author

**S. Venkata Ramana**
DevOps Engineer | AWS | Kubernetes | Terraform | CI/CD

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/venkata-ramana-sanga-176936401)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=flat-square&logo=github)](https://github.com/venkata-ramana)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

> ⭐ If you found this useful, please star the repository!
