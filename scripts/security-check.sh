#!/usr/bin/env bash
set -euo pipefail

# Security checks: Trivy (image) and Checkov (Terraform)
# Requires: trivy, docker, python3 or docker to run checkov container

IMAGE_REF=${1:-demo:scan}

echo "[Trivy] Scanning $IMAGE_REF ..."
trivy image --exit-code 0 --severity CRITICAL,HIGH,MEDIUM "$IMAGE_REF" || true

echo "[Checkov] Scanning Terraform ..."
docker run --rm -v "$PWD/terraform:/tf":ro bridgecrew/checkov:3.2.404 --directory /tf --framework terraform --quiet --soft-fail
echo "Security checks completed."


