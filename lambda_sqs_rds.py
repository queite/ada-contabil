import json
import os
import pymysql
import logging


logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    # Connect to RDS
    rds_host = os.getenv('RDS_PROXY_ENDPOINT')
    db_username = os.getenv('RDS_USERNAME')
    db_password = os.getenv('RDS_PASSWORD')
    db_name = os.getenv('RDS_DB_NAME')

    try:
        connection = pymysql.connect(
            host=rds_host,
            user=db_username,
            password=db_password,
            database=db_name
        )
        print("Conexão com RDS bem-sucedida")
    except Exception as e:
        print(f"Erro ao conectar ao RDS: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Erro ao conectar ao RDS'})
        }

    # Process SQS message
    record = event['Records'][0]
    message_body = json.loads(record['body'])
    message = json.loads(message_body['Message'])
    file_name = message['file_name']
    num_lines = message['num_lines']

    # Save on RDS
    try:
        with connection.cursor() as cur:
            cur.execute("create table if not exists files (\
                        file-name varchar(255), num-lines int NOT NULL")
            sql = "INSERT INTO files (file_name, num_lines) VALUES (%s, %s)"
            cur.execute(sql, (file_name, num_lines))
            connection.commit()
            cur.execute("select * from Customer")
            logger.info(
                "O seguinte registro foi adicionado no banco de dados:"
            )
            logger.info(cur)
            connection.commit()
    except Exception as e:
        print(f"Erro ao gravar no RDS: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Erro ao gravar no RDS'})
        }
    finally:
        connection.close()

    return {
        'statusCode': 200,
        'body': json.dumps({
            'file_name': file_name,
            'num_lines': num_lines,
            'message': "Salvo no RDS"})
    }
