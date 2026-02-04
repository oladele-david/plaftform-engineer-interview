# Lambda Function: EC2 Instance Reboot with SNS Notification

## Overview
This AWS Lambda function reboots a specified EC2 instance and sends a notification via Amazon SNS.

## Prerequisites
- AWS Lambda execution role with the following permissions:
    - `ec2:RebootInstances`
    - `sns:Publish`
- Python 3.x runtime
- Boto3 library (included in Lambda runtime)

## Environment Variables
| Variable | Description | Example |
|----------|-------------|---------|
| `INSTANCE_ID` | The EC2 instance ID to reboot | `i-1234567890abcdef0` |
| `SNS_TOPIC_ARN` | SNS topic ARN for notifications | `arn:aws:sns:us-east-1:123456789012:ec2-notifications` |

## Functionality
1. Connects to AWS EC2 and SNS services
2. Reboots the EC2 instance specified in `INSTANCE_ID`
3. Publishes a notification message to the SNS topic
4. Returns a success response with details

## Return Value
```json
{
    "status": "success",
    "message": "EC2 instance i-xxxxx rebooted and notification sent."
}
```

## Deployment
1. Create a Lambda function in AWS Console
2. Copy the code into the function
3. Set the required environment variables
4. Configure appropriate IAM role permissions
5. Test the function

## Usage
Trigger this function via:
- CloudWatch Events/EventBridge (scheduled)
- Manual invocation
- API Gateway
- Other AWS services
