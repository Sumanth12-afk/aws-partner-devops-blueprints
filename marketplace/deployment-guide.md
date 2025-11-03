# Deployment Guide

This guide explains how to deploy the “AWS Partner DevOps Automation for Startups” offer.

## Prerequisites
- AWS account with appropriate permissions (Administrator or scoped roles)
- GitHub repository access
- AWS CLI and Terraform >= 1.6 (if running locally)

## Steps
1. Clone the repository and review `terraform/` and `.github/workflows/`.
2. Configure Terraform backend (`terraform/backend.tf`) with your S3 bucket and DynamoDB table.
3. Set GitHub Actions secrets as per `docs/github-secrets.md`.
4. Run Terraform (locally or via pipeline):
   - `cd terraform && terraform init && terraform plan && terraform apply -auto-approve`
5. Build and push the container (CI/CD auto builds on push/PR per workflow config).
6. Deploy to ECS (or adapt for EKS using manifests in `k8s/`).

## Post Deployment
- Validate networking (public/private subnets, routes, SGs).
- Confirm ECS/EKS workloads are healthy.
- Check CloudWatch metrics/alarms and cost alerts.

## Rollback
- Redeploy a previous image tag (ECS force-new-deployment).
- Revert recent Terraform change and re-apply.

## Security
- Trivy and Checkov run in CI for images and Terraform policies.
- Use least-privilege IAM and OIDC where possible.

## Support
Contact: sumanthnallandhigal@gmail.com
