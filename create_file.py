import random
from datetime import datetime
import os
import boto3
import io
from dotenv import load_dotenv

load_dotenv()


def generate_file():
    # Generate a random number of lines
    num_lines = random.randint(1, 100)

    # Create the file name
    now = datetime.now()
    timestamp = now.strftime("%Y%m%d_%H%M%S_%f")
    file_name = f"{timestamp}.txt"

    # Write the random number of lines to the file
    file_content = io.StringIO()
    for i in range(num_lines):
        file_content.write(f"This is line {i+1} of text.\n")

    print(f"Generated file: {file_name} with {num_lines} lines")
    upload_to_s3(file_name, file_content.getvalue())


def upload_to_s3(file_name, file_content):
    s3 = boto3.client('s3')
    bucket_name = os.getenv('S3_BUCKET_NAME')
    s3.put_object(Bucket=bucket_name, Key=file_name, Body=file_content)
    print(f"Uploaded {file_name} to S3 using boto3")
    send_sns_notification(file_name)


def send_sns_notification(file_name):
    sns = boto3.client('sns')
    topic_arn = os.getenv('SNS_TOPIC_ARN')
    message = f"File {file_name} has been uploaded to S3."
    sns.publish(TopicArn=topic_arn, Message=message)
    print(f"Sent SNS notification for {file_name}")


if __name__ == "__main__":
    generate_file()
