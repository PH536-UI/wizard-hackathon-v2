import json
import os
import time
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])


def handler(event, context):
    processed = 0

    for record in event.get("Records", []):
        body = json.loads(record["body"])

        item = {
            "pk": "lead",
            "sk": str(int(time.time() * 1000)),
            "name": body.get("name", "unknown"),
            "email": body.get("email", "unknown"),
            "processed_at": int(time.time()),
        }

        table.put_item(Item=item)
        processed += 1

    return {
        "statusCode": 200,
        "processed": processed,
    }
