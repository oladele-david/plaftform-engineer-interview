# Platform Engineer Coding Test - PacerPro

**Candidate:** Oladele David Temidayo

This repository contains my solutions for the PacerPro Platform Engineer coding assessment, demonstrating monitoring and automation capabilities for web application performance issues.

## Test Scenario

The scenario involves creating a monitoring and automation solution to identify and resolve intermittent web application performance issues automatically.

## Repository Structure

```
.
├── terraform/              # Infrastructure as Code
│   ├── main.tf            # EC2, Lambda, SNS resources
│   └── README.md          # Deployment guide
├── lambda_function/        # Lambda automation code
│   └── lambda_function.py # EC2 reboot handler
└── sumo_logic_query.txt   # Performance monitoring query
```

## Solutions

### Part 1: Sumo Logic Query and Alert (10 minutes)

**Objective:** Monitor API performance and alert on degradation

Implemented a Sumo Logic query that:
- Identifies log entries where `/api/data` endpoint response time exceeds 3 seconds
- Groups results in 10-minute windows
- Can be configured to alert when more than 5 slow responses detected

**Query file:** [sumo_logic_query.txt](sumo_logic_query.txt)

**Recording:** [Part 1 - Sumo Logic Implementation](https://drive.google.com/file/d/1mRr8gfNADAEGFWN8kgQYlj1wqvwGEGZS/view?usp=sharing)

### Part 2: AWS Lambda Function (20 minutes)

**Objective:** Automated remediation via Lambda

Created a Python Lambda function that:
- Gets triggered by Sumo Logic alerts (or manually)
- Reboots the specified EC2 instance
- Logs the action to CloudWatch
- Sends notification via SNS topic

**Code:** [lambda_function/lambda_function.py](lambda_function/lambda_function.py)

**Recording:** [Part 2 - Lambda Function Development](https://drive.google.com/file/d/1X-gNxY6v-UPnTqvmH3FYTgitc1T9l6ME/view?usp=sharing)

### Part 3: Infrastructure as Code (15 minutes)

**Objective:** Deploy infrastructure using Terraform

Terraform configuration includes:
- EC2 instance (t2.micro with Amazon Linux 2023)
- Lambda function with Python 3.13 runtime
- SNS topic with email subscription
- IAM roles with least privilege permissions:
  - CloudWatch Logs access for Lambda
  - EC2 reboot permissions (scoped to specific instance)
  - SNS publish permissions

**Configuration:** [terraform/](terraform/)

**Recording:** [Part 3 - Terraform Deployment](https://drive.google.com/file/d/1Q5QuDMFT_byo-HOtNBalHSw8uBIYSY6s/view?usp=sharing)

## Deployment Instructions

### Prerequisites
- AWS account with appropriate IAM permissions
- Terraform installed (v0.12+)
- AWS CLI configured with credentials
- Python 3.13 compatible environment

### Steps

1. **Package the Lambda function:**
   ```bash
   cd lambda_function
   zip ../terraform/lambda_function.zip lambda_function.py
   cd ../terraform
   ```

2. **Deploy infrastructure:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Confirm SNS subscription:**
   Check your email and click the confirmation link to receive notifications.

4. **Test the Lambda function:**
   ```bash
   aws lambda invoke \
     --function-name Pacerpro-Reboot-Automation \
     --region us-east-1 \
     output.json
   ```

For detailed information, see [terraform/README.md](terraform/README.md)

## Technologies Used

- **Terraform** - Infrastructure as Code
- **AWS Lambda** - Serverless compute (Python 3.13)
- **AWS EC2** - Target compute instance
- **AWS SNS** - Email notifications
- **AWS IAM** - Least privilege access control
- **Sumo Logic** - Log monitoring and alerting

## Key Features

- **Automated Remediation:** Lambda automatically reboots EC2 on alert
- **Least Privilege IAM:** Roles scoped to specific resources and actions
- **Email Notifications:** Real-time alerts via SNS
- **Performance Monitoring:** Identifies slow API responses in real-time
- **Infrastructure as Code:** Fully reproducible deployment

## Notes

- All resources are configured for us-east-1 region
- EC2 instance uses t2.micro for cost efficiency
- Lambda timeout set to 15 seconds
- Query designed for 10-minute time slices to match alert window
