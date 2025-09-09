import boto3
from boto3.dynamodb.conditions import Attr
from datetime import datetime

# Brug din SSO-profil
session = boto3.Session(profile_name='vpr-prod')

# Dit tabelnavn
table_name = 'ovp-catalog'

# Forbind til DynamoDB
dynamodb = session.resource('dynamodb')
table = dynamodb.Table(table_name)

print("Scanner tabellen – dette kan tage lidt tid...")

# Get current date in ISO format
current_date = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')

# Alias for 'Type', som er et reserveret ord
expression_attribute_names = {
    "#t": "Type"
}

# Første scan
response = table.scan(
    FilterExpression=Attr("Type").eq("SERIES") & 
                    Attr("AvailabilityState").ne("unavailable"),
    ProjectionExpression="#t, Title, WebRef, AvailabilityState",
    ExpressionAttributeNames=expression_attribute_names
)

items = response["Items"]

# Håndter pagination
while "LastEvaluatedKey" in response:
    response = table.scan(
        FilterExpression=Attr("Type").eq("SERIES") & 
                        Attr("AvailabilityState").ne("unavailable"),
        ProjectionExpression="#t, Title, WebRef, AvailabilityState",
        ExpressionAttributeNames=expression_attribute_names,
        ExclusiveStartKey=response["LastEvaluatedKey"]
    )
    items.extend(response["Items"])

# Find længste Title
if not items:
    print("Ingen entries fundet med Type = 'SERIES' og AvailabilityState != 'unavailable'")
else:
    longest = max(items, key=lambda x: len(x.get("Title", "")))
    print("\nEntry med længste 'Title':")
    print(f"Title: {longest['Title']}")
    print(f"Længde: {len(longest['Title'])} tegn")
    print(f"Type: {longest['Type']}")
    print(f"URL: {longest['WebRef']}")
    print(f"AvailabilityState: {longest['AvailabilityState']}")