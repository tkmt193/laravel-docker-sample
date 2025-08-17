# ローカル用
build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose down
	docker compose up -d

logs:
	docker compose logs -f

enter-%:
	docker compose exec $* bash

# 本番用
# Makefile

# 変数設定
AWS_PROFILE ?= tsukamoto-for-windows
AWS_REGION ?= ap-northeast-1
AWS_ACCOUNT_ID ?= 264008915581
REPO_NAME ?= laravel-sample
IMAGE_TAG ?= latest
IMAGE_NAME := $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(REPO_NAME):$(IMAGE_TAG)

# ECRリポジトリ作成（初回のみ）
create-ecr:
	aws-vault exec $(AWS_PROFILE) -- aws ecr create-repository --repository-name $(REPO_NAME) || true

# Dockerイメージビルド～プッシュまで
deploy:
	docker build -t $(REPO_NAME):$(IMAGE_TAG) .
	aws-vault exec $(AWS_PROFILE) -- aws ecr get-login-password --region $(AWS_REGION) | \
	docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
	docker tag $(REPO_NAME):$(IMAGE_TAG) $(IMAGE_NAME)
	docker push $(IMAGE_NAME)

TERRAFORM_DIR = .

tf-init:
	terraform -chdir=$(TERRAFORM_DIR) init -reconfigure

tf-%: format
	terraform -chdir=$(TERRAFORM_DIR) $*
	
format:
	terraform fmt -recursive

# インフラ停止・再開
stop:
	./stop-infrastructure.sh

start:
	./start-infrastructure.sh

# 状態確認
status:
	@echo "=== ECS Service Status ==="
	aws ecs describe-services --cluster my-cluster --services my-app-service --region ap-northeast-1 --query 'services[0].{Status:status,RunningCount:runningCount,DesiredCount:desiredCount}' --output table
	@echo ""
	@echo "=== RDS Status ==="
	aws rds describe-db-instances --db-instance-identifier terraform-20250816132605887900000001 --region ap-northeast-1 --query 'DBInstances[0].{Status:DBInstanceStatus,Engine:Engine,Endpoint:Endpoint}' --output table

# マイグレーション
create-%:
	docker compose exec app php artisan make:migration $*

migrate:
	docker compose exec app php artisan migrate

status:
	docker compose exec app php artisan migrate:status

rollback:
	docker compose exec app php artisan migrate:rollback
