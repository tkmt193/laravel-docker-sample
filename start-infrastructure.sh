#!/bin/bash

# 色付きの出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== ECSとRDS再開スクリプト ===${NC}"

# AWSリージョン設定
REGION="ap-northeast-1"
CLUSTER_NAME="my-cluster"
SERVICE_NAME="my-app-service"
DB_INSTANCE_ID="terraform-20250816132605887900000001"

echo -e "${YELLOW}1. RDSインスタンスの開始...${NC}"
aws rds start-db-instance \
    --db-instance-identifier $DB_INSTANCE_ID \
    --region $REGION

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ RDSインスタンスの開始完了${NC}"
    echo -e "${YELLOW}   RDSの起動完了まで数分かかります...${NC}"
else
    echo -e "${RED}✗ RDSインスタンスの開始失敗${NC}"
    exit 1
fi

echo -e "${YELLOW}2. RDSの起動完了を待機...${NC}"
aws rds wait db-instance-available \
    --db-instance-identifier $DB_INSTANCE_ID \
    --region $REGION

echo -e "${GREEN}✓ RDSインスタンスの起動完了${NC}"

echo -e "${YELLOW}3. ECSサービスのスケールアップ...${NC}"
aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $SERVICE_NAME \
    --desired-count 1 \
    --region $REGION

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ ECSサービスのスケールアップ完了${NC}"
else
    echo -e "${RED}✗ ECSサービスのスケールアップ失敗${NC}"
    exit 1
fi

echo -e "${YELLOW}4. ECSタスクの起動を待機...${NC}"
aws ecs wait services-stable \
    --cluster $CLUSTER_NAME \
    --services $SERVICE_NAME \
    --region $REGION

echo -e "${GREEN}✓ ECSタスクの起動完了${NC}"

echo -e "${GREEN}=== 再開処理完了 ===${NC}"
echo -e "${YELLOW}ALBのDNS名: my-app-alb-1667561419.ap-northeast-1.elb.amazonaws.com${NC}" 