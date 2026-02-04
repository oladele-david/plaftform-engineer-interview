import boto3, os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    sns = boto3.client('sns')
    instance_id = os.environ['INSTANCE_ID']
    ec2.reboot_instances(InstanceIds=[instance_id]) #restart Instance
    sns.publish(
        TopicArn = os.environ['SNS_TOPIC_ARN'],
        Message = "Instance Rebooted"
    )
    
    return {
        'status': "success",
    }