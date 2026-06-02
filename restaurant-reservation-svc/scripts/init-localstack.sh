#!/bin/bash
# Inicializa recursos en LocalStack para reservation-svc
set -e

AWS_ENDPOINT="http://localhost:4566"
AWS_REGION="us-east-1"
AWS_CMD="aws --endpoint-url=$AWS_ENDPOINT --region $AWS_REGION"
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test

echo "▶ Creando tabla DynamoDB restaurant-reservations..."
$AWS_CMD dynamodb create-table \
    --table-name restaurant-reservations \
    --attribute-definitions \
        AttributeName=restaurant_id,AttributeType=S \
        AttributeName=reservation_datetime,AttributeType=S \
    --key-schema \
        AttributeName=restaurant_id,KeyType=HASH \
        AttributeName=reservation_datetime,KeyType=RANGE \
    --billing-mode PAY_PER_REQUEST \
    --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES \
    || echo "(ya existe)"

echo "▶ Creando topic SNS restaurant-notifications..."
$AWS_CMD sns create-topic \
    --name restaurant-notifications \
    || echo "(ya existe)"

echo "✔ LocalStack listo para reservation-svc"