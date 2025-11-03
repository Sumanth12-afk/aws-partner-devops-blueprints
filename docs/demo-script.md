# Demo Script

This script walks through the repository to demonstrate AWS Partner DevOps capabilities.

## 1) IaC – Terraform
- Review `terraform/` structure and variables
- `terraform init && terraform plan` (explain remote backend)
- Highlight VPC, subnets, NAT, SGs, ECS cluster, alarms

## 2) CI/CD – GitHub Actions
- Show `.github/workflows/ci-cd-pipeline.yml`
- Explain build → scan → push → terraform apply → ECS deploy
- Mention separate `trivy-scan.yml` and `checkov-scan.yml`

## 3) Kubernetes – EKS Alignment
- Review `k8s/` Deployment, Service (LB), Ingress (ALB), Secrets
- Explain ingress class `alb` and IRSA note

## 4) DevSecOps
- Trivy scan of images
- Checkov scan of Terraform

## 5) FinOps
- `scripts/cost-alerts.py` to configure billing alarms via SNS

## 6) Wrap-up
- Show outputs in `terraform/outputs.tf`
- Describe next steps: ALB + WAF + CloudTrail roadmap

