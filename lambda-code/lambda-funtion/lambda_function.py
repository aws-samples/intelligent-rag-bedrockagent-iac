## Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
## SPDX-License-Identifier: MIT-0

import json
def calculate_bmi(weight, height):
    """Calculate BMI given weight (kg) and height (m)."""
    return weight / (height ** 2)
def lambda_handler(event, context):
    try:
        # Extract parameters from the event
        request_body = event['requestBody']['content']['application/json']['properties']
        weight = None
        height = None
        for prop in request_body:
            if prop['name'] == 'weight':
                weight = float(prop['value'])
            elif prop['name'] == 'height':
                height = float(prop['value'])
        if weight is None or height is None:
            raise KeyError('weight' if weight is None else 'height')
        # Calculate BMI
        bmi = calculate_bmi(weight, height)
        # Prepare response
        response = {
            'bmi': round(bmi, 2)
        }
        print(response)
        # Format the response for Bedrock
        result = {
            "messageVersion": "1.0",
            "response": {
                "actionGroup": event.get("actionGroup"),
                "apiPath": event.get("apiPath"),
                "httpMethod": event.get("httpMethod"),
                "httpStatusCode": 200,
                "responseBody": {
                    "application/json": {
                        "body": json.dumps(response)
                    }
                },
                "sessionAttributes": {},
                "promptSessionAttributes": {}
            }
        }
        return result
    except KeyError as e:
        error_response = f"Missing parameter: {str(e)}"
        print(error_response)
        return format_error_response(400, error_response)
    except ValueError as e:
        error_response = f"Invalid parameter value: {str(e)}"
        print(error_response)
        return format_error_response(400, error_response)
    except Exception as e:
        error_response = f"An error occurred: {str(e)}"
        print(error_response)
        return format_error_response(500, error_response)
def format_error_response(status_code, error_message):
    return {
        "messageVersion": "1.0",
        "response": {
            "actionGroup": None,
            "apiPath": None,
            "httpMethod": None,
            "httpStatusCode": status_code,
            "responseBody": {
                "application/json": {
                    "body": json.dumps({"error": error_message})
                }
            },
            "sessionAttributes": {},
            "promptSessionAttributes": {}
        }
    }