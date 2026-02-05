provider "aws" {
  region = "us-east-1"
}

#SNS Topic setup
resource "aws_sns_topic" "pacerpro_alerts" {
  name = "Pacerpro-Alerts"
}

#SNS Topic Subscription
resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.pacerpro_alerts.arn
  protocol  = "email"
  endpoint  = "oladeledavidtemidayo@gmail.com"
}

#IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
    name = "pacerpro_lambda_exec_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}

#IAM Policy Attachment for Lambda Role
resource "aws_iam_role_policy" "lambda_policy" {
    name = "pacerpro_lambda_policy"
    role = aws_iam_role.lambda_exec_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Effect   = "Allow"
                Resource = "arn:aws:logs:*:*:*"
            },
            {
                Action = [
                    "sns:Publish"
                ]
                Effect   = "Allow"
                Resource = aws_sns_topic.pacerpro_alerts.arn
            },
            {
                Action = [
                    "ec2:RebootInstances"
                ]
                Effect   = "Allow"
                Resource = aws_instance.web_app.arn
            }
        ]
    })
}

#Lambda Function
resource "aws_lambda_function" "reboot_lambda" {
    filename = "lambda_function.zip"
    function_name = "Pacerpro-Reboot-Automation"
    role = aws_iam_role.lambda_exec_role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.13"
    timeout = 15

    environment {
        variables = {
            INSTANCE_ID = aws_instance.web_app.id
            SNS_TOPIC_ARN = aws_sns_topic.pacerpro_alerts.arn
        }
    }
}

#Instance EC2 to monitor
resource "aws_instance" "web_app" {
    ami ="ami-0b6c6ebed2801a5cb"
    instance_type = "t2.micro"
    tags = {
        Name = "PacerPro-Web_App"
    }
}