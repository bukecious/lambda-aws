import boto3
def post_handler(event, context):
    sns= boto3.client('sns')
    response = sns.publish(
        TopicArn='arn:aws:sns:eu-west-1:538353771716:mytopic',
        Message='testinglambda'
        )
    return{
        "message" : "successful"
        }
