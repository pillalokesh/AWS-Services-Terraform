import json

def lambda_handler(event, context):
    """
    Sample Lambda function that processes events
    """
    print(f"Received event: {json.dumps(event)}")
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello from Lambda!',
            'event': event
        })
    }
