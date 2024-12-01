import json
import os
import boto3

s3 = boto3.client('s3')
sns = boto3.client('sns')


def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    try:
        bucket_name = event['Records'][0]['s3']['bucket']['name']
        file_name = event['Records'][0]['s3']['object']['key']

        file_content = read_file_from_s3(bucket_name, file_name)

        num_lines = len(file_content.splitlines())

        message = {
            'file_name': file_name,
            'num_lines': num_lines
        }

        response = sns.publish(
            TopicArn=os.getenv('SNS_TOPIC_ARN'),
            Message=json.dumps(message),
            Subject=f'Novo arquivo no bucket {bucket_name}'
        )
        print(f"Sent message to SNS: {response['MessageId']}")

    except Exception as e:
        print(f"Error: {e}")
        raise e


def read_file_from_s3(bucket_name, file_name):
    # Get information about the file, including content
    response = s3.get_object(Bucket=bucket_name, Key=file_name)
    # Get the content from the key body
    file_content = response['Body'].read().decode('utf-8')
    return file_content
