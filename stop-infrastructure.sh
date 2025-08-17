#!/bin/bash

# 色付きの出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== ECSとRDS停止スクリプト ===${NC}"

# AWSリージョン設定
REGION="ap-northeast-1"
CLUSTER_NAME="my-cluster"
SERVICE_NAME="my-app-service"
DB_INSTANCE_ID="terraform-20250816132605887900000001"

echo -e "${YELLOW}1. ECSサービスのスケールダウン...${NC}"
aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $SERVICE_NAME \
    --desired-count 0 \
    --region $REGION

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ ECSサービスのスケールダウン完了${NC}"
else
    echo -e "${RED}✗ ECSサービスのスケールダウン失敗${NC}"
    exit 1
fi

echo -e "${YELLOW}2. ECSタスクの停止を待機...${NC}"
aws ecs wait services-stable \
    --cluster $CLUSTER_NAME \
    --services $SERVICE_NAME \
    --region $REGION

echo -e "${GREEN}✓ ECSタスクの停止完了${NC}"

echo -e "${YELLOW}3. RDSインスタンスの停止...${NC}"
aws rds stop-db-instance \
    --db-instance-identifier $DB_INSTANCE_ID \
    --region $REGION

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ RDSインスタンスの停止開始${NC}"
    echo -e "${YELLOW}   RDSの停止完了まで数分かかります...${NC}"
else
    echo -e "${RED}✗ RDSインスタンスの停止失敗${NC}"
    exit 1
fi

echo -e "${GREEN}=== 停止処理完了 ===${NC}"
echo -e "${YELLOW}注意: インフラを完全に削除する場合は 'make tf-destroy' を実行してください${NC}" 