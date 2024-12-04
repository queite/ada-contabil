import json
import os
import redis


def lambda_handler(event, context):
    # Connect to Elasticache
    elasticache_endpoint = os.getenv('ELASTICACHE_ENDPOINT')
    r = redis.StrictRedis(
        host=elasticache_endpoint,
        port=6379,
        decode_responses=True)

    # Process SQS message
    record = event['Records'][0]
    message_body = json.loads(record['body'])
    message = json.loads(message_body['Message'])
    print("message")
    print(message)

    try:
        r.ping()  # Testa a conexão
        print("Conexão com Elasticache bem-sucedida")
    except Exception as e:
        print(f"Erro ao conectar ao Elasticache: {e}")

    # Save data on Elasticache
    file_name = message['file_name']
    print(file_name)
    num_lines = message['num_lines']
    print(num_lines)
    r.set(file_name, num_lines)

    return {
        'statusCode': 200,
        'body': json.dumps({
            'file_name': file_name,
            'num_lines': num_lines,
            'message': "saved on elasticache"})
    }
