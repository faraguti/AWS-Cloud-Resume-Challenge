# Import necessary libraries
import json
import boto3

# Initialize DynamoDB resource and set the region
dynamodb = boto3.resource('dynamodb', region_name='us-west-2')

# Specify the DynamoDB table to work with
table = dynamodb.Table('cloud-resume-challenge')

# Lambda function entry point
def lambda_handler(event, context):
    # Retrieve item from DynamoDB using composite primary key
    response = table.get_item(
        Key={"pk": "1", "sk": "1"})

    # Extract existing 'visits' attribute or set to 0
    item = response.get("Item", {})
    visits = item.get("visits", 0)
    
    # Increment 'visits' count
    visits = visits + 1
    
    # Update 'visits' attribute in DynamoDB
    table.put_item(Item={"pk": "1", "sk": "1", "visits": visits})
    
    return visits
