#!/usr/bin/env bash
set -euo pipefail

# Deploy script: build & push image, apply Terraform, refresh ECS service
# Requirements: awscli v2, docker, terraform

AWS_REGION=${AWS_REGION:-us-east-1}
ECR_REPOSITORY=${ECR_REPOSITORY:-demo-repo}
IMAGE_TAG=${IMAGE_TAG:-$(git rev-parse --short HEAD 2>/dev/null || date +%s)}
TF_DIR=${TF_DIR:-terraform}
ECS_CLUSTER=${ECS_CLUSTER:-demo-cluster}
ECS_SERVICE=${ECS_SERVICE:-demo-service}

echo "[1/4] Logging into ECR..."
aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin "$(aws sts get-caller-identity --query Account --output text).dkr.ecr.${AWS_REGION}.amazonaws.com"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="$ACCOUNT_ID.dkr.ecr.${AWS_REGION}.amazonaws.com/$ECR_REPOSITORY"

echo "[2/4] Building and pushing Docker image $ECR_URI:$IMAGE_TAG ..."
docker build -t "$ECR_REPOSITORY:$IMAGE_TAG" .
docker tag "$ECR_REPOSITORY:$IMAGE_TAG" "$ECR_URI:$IMAGE_TAG"
docker push "$ECR_URI:$IMAGE_TAG"

echo "[3/4] Terraform apply..."
pushd "$TF_DIR" >/dev/null
terraform init -input=false
terraform apply -auto-approve -input=false
popd >/dev/null

echo "[4/4] Forcing new ECS deployment..."
aws ecs update-service --cluster "$ECS_CLUSTER" --service "$ECS_SERVICE" --force-new-deployment >/dev/null
echo "Done. Image: $ECR_URI:$IMAGE_TAG"


