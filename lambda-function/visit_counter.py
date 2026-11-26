"""Visit counter for the Cloud Resume website.

Each call atomically increments the counter stored in DynamoDB and returns
the new total as a plain number, which API Gateway sends back as JSON.
"""
import os

import boto3

TABLE_NAME = os.environ.get("TABLE_NAME", "cloud-resume-challenge")
REGION = os.environ.get("AWS_REGION", "us-west-2")
COUNTER_KEY = {"pk": "1", "sk": "1"}

# Created on first use (not at import time) so tests can mock boto3, and
# reused across warm Lambda invocations.
_table = None


def get_table():
    global _table
    if _table is None:
        _table = boto3.resource("dynamodb", region_name=REGION).Table(TABLE_NAME)
    return _table


def lambda_handler(event, context):
    # ADD is atomic, so simultaneous visits are never lost, and it creates
    # the item with visits = 1 if it does not exist yet.
    response = get_table().update_item(
        Key=COUNTER_KEY,
        UpdateExpression="ADD visits :inc",
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW",
    )
    return int(response["Attributes"]["visits"])
