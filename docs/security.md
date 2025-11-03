# Security

This project integrates DevSecOps from day one: secure-by-default baselines, automated checks, and clear ownership.

## Pipeline Security Gates
- Trivy: container image vulnerability scanning (CRITICAL/HIGH/MEDIUM reported)
- Checkov: Terraform policy checks (CIS/AWS FSBP mappings)
- Soft-fail configurable to hard-fail for CRITICAL/HIGH

## IAM & Access
- Least-privilege IAM roles for CI/CD and runtime
- ECS task execution role for pulling images and CloudWatch logs
- For EKS (optional): IRSA for pod-level IAM scoping

## Secrets Management
- Use GitHub Actions secrets or AWS Secrets Manager/Parameter Store
- Avoid storing secrets in code or Terraform vars files
- Rotate regularly and audit access

## Network Security
- Segmented VPC with public and private subnets
- Security groups for web and app tiers (narrowed ingress)
- NAT for private egress; no inbound to private subnets

## Data & Logging
- Enable encryption at rest (EBS/EFS/RDS/S3) where applicable
- Centralized logging via CloudWatch; alarms for anomalies

## Compliance
- Track Checkov results and map to CIS/AWS FSBP
- Document exceptions with owner, rationale, and expiry
