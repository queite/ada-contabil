import boto3
import os

def configure_s3_bucket():
    s3 = boto3.client('s3')
    bucket_name = os.getenv('S3_BUCKET_NAME')
    sns_topic_arn = os.getenv('SNS_TOPIC_ARN')

    notification_configuration = {
        'TopicConfigurations': [
            {
                'TopicArn': sns_topic_arn,
                'Events': ['s3:ObjectCreated:*']
            }
        ]
    }

    s3.put_bucket_notification_configuration(
        Bucket=bucket_name,
        NotificationConfiguration=notification_configuration
    )

if __name__ == "__main__":
    configure_s3_bucket()
