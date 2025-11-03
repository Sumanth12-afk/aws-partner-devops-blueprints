# GitHub Actions Secrets Guide

Add these repository-level secrets in GitHub → Settings → Secrets and variables → Actions → New repository secret.

## Required
- AWS_ACCESS_KEY_ID: IAM user/role access key with least-privilege for ECR, ECS, CloudWatch, and Terraform-managed resources.
- AWS_SECRET_ACCESS_KEY: Secret key paired with AWS_ACCESS_KEY_ID.
- ECR_REPOSITORY: Name of your ECR repo (e.g., demo-repo).
- ECS_CLUSTER: Target ECS cluster name (for deploy workflow).
- ECS_SERVICE: Target ECS service name (for deploy workflow).
- CONTAINER_NAME: The container name in your ECS task definition to update.

## Optional
- TF_VAR_region: Override Terraform region (defaults to us-east-1).
- TF_VAR_project_name: Custom project identifier for tagging/names.
- OIDC_ROLE_ARN: If using GitHub OIDC to assume-role instead of long-lived keys.

## Permissions
Grant the IAM principal only the actions required:
- ECR: ecr:BatchGetImage, ecr:GetAuthorizationToken, ecr:PutImage
- ECS: ecs:UpdateService, ecs:DescribeServices, ecs:DescribeClusters
- CloudWatch/Logs (read), STS (AssumeRole when using OIDC), S3/DynamoDB for Terraform backend (if pipelines run apply)

Tip: Prefer OIDC with a trust policy to GitHub and attach least-privilege policies to the role.
