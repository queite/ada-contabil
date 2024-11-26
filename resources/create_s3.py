from dotenv import load_dotenv
import boto3
import os

load_dotenv()

s3_client = boto3.client('s3')
s3_client.create_bucket(Bucket=os.getenv("S3_BUCKET_NAME"))
