import json
import os
import time
import boto3

sqs = boto3.client("sqs")

QUEUE_URL = os.environ["QUEUE_URL"]


def handler(event, context):
    path = event.get("rawPath") or event.get("path") or "/"

    if path.rstrip("/").endswith("/health"):
        return _response(200, {
            "status": "ok",
            "ts": int(time.time())
        })

    if path.rstrip("/").endswith("/api/v1/resource"):
        body = event.get("body") or "{}"

        try:
            payload = json.loads(body)
        except json.JSONDecodeError:
            return _response(400, {
                "status": "error",
                "message": "invalid JSON"
            })

        message = {
            "name": payload.get("name", "demo"),
            "email": payload.get("email", "demo@example.com"),
            "created_at": int(time.time())
        }

        result = sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps(message)
        )

        return _response(202, {
            "status": "queued",
            "message_id": result["MessageId"]
        })

    return _response(404, {
        "status": "not_found",
        "path": path
    })


def _response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body)
    }
