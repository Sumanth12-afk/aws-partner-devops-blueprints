# CI/CD Pipeline

GitHub Actions orchestrates build → scan → push → provision → deploy.

## Workflows
- ci-cd-pipeline.yml: build Docker, Trivy scan, push to ECR, Terraform apply, ECS deploy
- trivy-scan.yml: ad-hoc image scanning
- checkov-scan.yml: Terraform policy scanning
- deploy-to-ecs.yml: force new ECS deployment on main merges

## Required Secrets
- AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
- ECR_REPOSITORY, ECS_CLUSTER, ECS_SERVICE, CONTAINER_NAME

## Environments
- Branch strategy: feature → PR → main
- Optional: add environments (dev/stage/prod) with protected approvals

## Rollback
- Re-deploy previous image tag via ECS
- Terraform state locked in S3 + DynamoDB for safe rollbacks

## Hardening Ideas
- Enable OIDC + role-based auth for GitHub to AWS (id-token)
- Make scanners fail the build on CRITICAL/HIGH
