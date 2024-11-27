import boto3

sns = boto3.resource('sns')
topic = sns.create_topic(Name="files_to_s3")

subscription = topic.subscribe(
  Protocol="", Endpoint="endpoint", ReturnSubscriptionArn=True
)
