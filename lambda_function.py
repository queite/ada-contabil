import boto3
import os
import json
import redis

def lambda_handler(event, context):
    # Connect to ElastiCache
    redis_host = os.getenv('ELASTICACHE_HOST')
    redis_port = os.getenv('ELASTICACHE_PORT', 6379)
    redis_client = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)

    # Process each SQS message
    for record in event['Records']:
        message_body = json.loads(record['body'])
        file_name = message_body['file_name']
        num_lines = message_body['num_lines']

        # Store file name and number of lines in ElastiCache
        redis_client.set(file_name, num_lines)

    return {
        'statusCode': 200,
        'body': json.dumps('Successfully processed SQS messages and stored data in ElastiCache')
    }
