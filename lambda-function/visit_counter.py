# Import required libraries
import json
import boto3

# Initialize a DynamoDB resource and set the region
dynamodb = boto3.resource('dynamodb', region_name='us-west-2')

# Specify the DynamoDB table to work with
table = dynamodb.Table('cloud-resume-challenge2')

# Lambda function entry point
def lambda_handler(event, context):
    # Retrieve item from DynamoDB using the 'Id' key
    response = table.get_item(Key={
        'Id': '1'
    })
    
    # Extract the 'visits' attribute from the response
    visits = response['Item']['visits']
    
    # Increment the 'visits' count
    visits = visits + 1
    
    # Print the updated 'visits' count (for Lambda logs)
    print(visits)
    
    # Update the 'visits' attribute in the DynamoDB item
    response = table.put_item(Item={
        'Id': '1',
        'visits': visits
    })
    
    # Return the updated 'visits' count as the Lambda response
    return visits