# EC2 Reboot Automation with Terraform

Automated EC2 instance reboot system that sends email notifications via SNS when a reboot occurs.

## What This Does

Sets up a Lambda function that can reboot an EC2 instance and notify you via email. Pretty straightforward - Lambda talks to EC2, reboots the instance, then fires off an SNS notification.

## What Gets Created

- EC2 instance (t2.micro) - the target instance
- Lambda function - handles the reboot logic
- SNS topic + email subscription - sends the notifications
- IAM role with policies - gives Lambda permission to reboot EC2 and publish to SNS

## Setup

First, package the Lambda function:

```bash
cd ../lambda_function
zip -j ../terraform/lambda_function.zip lambda_function.py
cd ../terraform
```

Then deploy:

```bash
terraform init
terraform plan
terraform apply
```

**Important:** After deployment, you'll get an email to confirm the SNS subscription. Click the link in that email or notifications won't work.

## How to Use It

Manually trigger the Lambda:

```bash
aws lambda invoke \
  --function-name Pacerpro-Reboot-Automation \
  --region us-east-1 \
  output.json
```

You could also hook this up to EventBridge if you want scheduled reboots or trigger it from CloudWatch alarms.

## Customizing

Things you might want to change in `main.tf`:

- Email address (line 13) - currently set to my email
- AWS region - defaults to us-east-1
- Instance type - using t2.micro now
- Lambda timeout - currently 15 seconds

## Tearing Down

```bash
terraform destroy
```

## Common Issues

**Lambda fails to reboot:** Check CloudWatch logs, usually it's an IAM permission issue.

**No email notifications:** Make sure you clicked the confirmation link in the SNS subscription email. Check spam folder.

**Terraform apply fails:** The lambda_function.zip needs to exist in this directory before running apply.

## Notes

- The IAM role only has permissions to reboot this specific EC2 instance
- Lambda runs on Python 3.13
- EC2 instance uses Amazon Linux 2023 AMI
- Costs are minimal - t2.micro is ~$8.50/month, Lambda and SNS are basically free at this scale
