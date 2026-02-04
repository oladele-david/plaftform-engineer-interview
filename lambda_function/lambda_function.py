import boto3, os


def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    sns = boto3.client('sns')
    
    instance_id = os.environ['INSTANCE_ID']
    ec2.reboot_instances(InstanceIds=[instance_id])
    sns.publish(
        TopicArn= os.environ['SNS_TOPIC_ARN'],
        Message=f'EC2 instance {instance_id} has been rebooted.',
        Subject='EC2 Reboot Notification'
    )
    
    return {
        'status': 'success',
        'message': f'EC2 instance {instance_id} rebooted and notification sent.'
    }
