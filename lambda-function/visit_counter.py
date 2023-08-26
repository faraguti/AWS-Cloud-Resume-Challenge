# Import required libraries
import json
import boto3

# Initialize a DynamoDB resource and set the region
dynamodb = boto3.resource('dynamodb', region_name='us-west-2')

# Specify the DynamoDB table to work with
table = dynamodb.Table('cloud-resume-challenge2')

# Lambda function entry point
def lambda_handler(event, context):
    # Retrieve items from DynamoDB using the GSI 'visit_count_index'
    response = table.get_item(
        Key={"pk" : "1", "sk": "1"})
        
    item = response.get("Item", {})
    visits = item.get("visits", 0)
    
    visits = visits + 1
    
    table.put_item(Item={"pk": "1", "sk": "1", "visits": visits})
    
    return visits
