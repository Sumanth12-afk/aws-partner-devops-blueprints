#!/usr/bin/env bash
set -euo pipefail

# Cleanup script: destroys Terraform resources and (optionally) purges ECR images

AWS_REGION=${AWS_REGION:-us-east-1}
ECR_REPOSITORY=${ECR_REPOSITORY:-demo-repo}
TF_DIR=${TF_DIR:-terraform}
PURGE_ECR=${PURGE_ECR:-false}

echo "[1/2] Terraform destroy ..."
pushd "$TF_DIR" >/dev/null
terraform destroy -auto-approve -input=false || true
popd >/dev/null

if [[ "$PURGE_ECR" == "true" ]]; then
  ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
  ECR_URI="$ACCOUNT_ID.dkr.ecr.${AWS_REGION}.amazonaws.com/$ECR_REPOSITORY"
  echo "[2/2] Deleting all images from $ECR_URI ..."
  DIGESTS=$(aws ecr list-images --repository-name "$ECR_REPOSITORY" --query 'imageIds[*]' --output json)
  if [[ "$DIGESTS" != "[]" ]]; then
    aws ecr batch-delete-image --repository-name "$ECR_REPOSITORY" --image-ids "$DIGESTS" || true
  fi
fi

echo "Cleanup completed."


