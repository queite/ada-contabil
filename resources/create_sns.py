import boto3

sns = boto3.resource('sns')
topic = sns.create_topic(Name="files_to_s3")

subscription = topic.subscribe(
  Protocol="sqs", Endpoint="arn:aws:sqs:us-east-1:123456789012:my-queue", ReturnSubscriptionArn=True
)
