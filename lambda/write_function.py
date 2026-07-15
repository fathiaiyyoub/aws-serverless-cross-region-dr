import json

import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("HighAvailabilityTable")


def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))

        item_id = body["ItemId"]
        data = body["Data"]

        table.put_item(
            Item={
                "ItemId": item_id,
                "Data": data,
            }
        )

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            "body": json.dumps({"message": "Item saved successfully"}),
        }

    except Exception as error:
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            "body": json.dumps({"error": str(error)}),
        }