import boto3
import json
import os
import redis

def lambda_handler(event, context):
    # Connect to Elasticache
    elasticache_endpoint = os.getenv('ELASTICACHE_ENDPOINT')
    r = redis.StrictRedis(host=elasticache_endpoint, port=6379, decode_responses=True)

    for record in event['Records']:
        # Process SQS message
        message_body = record['body']
        message = json.loads(message_body)

        # Save data to Elasticache
        file_name = message['file_name']
        num_lines = message['num_lines']
        r.set(file_name, num_lines)

    return {
        'statusCode': 200,
        'body': json.dumps('Message processed and saved to Elasticache')
    }
