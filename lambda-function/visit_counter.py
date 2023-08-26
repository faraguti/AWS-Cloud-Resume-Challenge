import json
import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-west-2')
table = dynamodb.Table('cloud-resume-challenge')

def lambda_handler(event, context):
    response = table.get_item(Key={
        'id':'1'
    })
    
    visits = response['Item']['visits']
    visits = visits + 1
    print(visits)
    
    response = table.put_item(Item={
        'id':'1',
        'visits': visits
    })
    
    return visits