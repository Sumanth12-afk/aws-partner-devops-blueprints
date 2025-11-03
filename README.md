# AWS Partner DevOps Showcase – Terraform VPC, CI/CD, Kubernetes & DevSecOps for Startups

This repository is a professional, AWS Partner–branded showcase built by Sumanth Nallandhigal (AWS Partner & DevOps Engineer) to demonstrate production-grade DevOps automation on AWS. It combines Infrastructure as Code, CI/CD, Kubernetes, and DevSecOps best practices with cost awareness.

## Overview
As an AWS Partner, this project illustrates how I deliver secure, scalable, and automated cloud foundations using Terraform, GitHub Actions, Docker, Kubernetes, and security scanners. It includes a complete VPC, optional ECS/EKS deployment patterns, and a CI/CD pipeline integrated with Trivy and Checkov.

## Features
- ⚙️ Terraform: Full VPC (VPC, IGW, NAT, public/private subnets, routes, security groups) with remote state (S3 + DynamoDB); ECS cluster + IAM baseline
- ☁️ CI/CD: GitHub Actions pipeline to build, scan, push to ECR, and deploy to ECS
- 🔐 DevSecOps: Trivy image scanning and Checkov Terraform policy scanning
- 🧩 Kubernetes: Demo manifests for EKS-aligned Deployment, Service, Ingress, and Secrets
- 💼 FinOps: Cost alert script and cleanup utilities

## Architecture Diagram
See `docs/architecture-diagram.png` (placeholder).

## Tech Stack
AWS, Terraform, GitHub Actions, Docker, Kubernetes, Trivy, Checkov, CloudWatch

## Related Terraform Modules
For additional production-ready Terraform modules (networking, compute, security, monitoring, etc.), see: [terraform-aws-startup-infrastructure](https://github.com/Sumanth12-afk/terraform-aws-startup-infrastructure)

## Container Image
This repo includes a multi-stage Dockerfile that builds a tiny Go HTTP server and runs it on a distroless, non-root image (port 8080) for demo purposes.

Build and run locally:

```bash
docker build -t devops-showcase:latest .
docker run -p 8080:8080 devops-showcase:latest
```

## Repository Secrets
See `docs/github-secrets.md` for the list of required GitHub Actions secrets and recommended IAM permissions.

## Why This Project Matters
This repository reflects the implementation quality expected of AWS Partners: secure-by-default baselines, automated pipelines, infrastructure immutability, and continuous compliance with pragmatic cost controls.

## Services I Offer
- CI/CD pipeline setup
- Terraform infrastructure automation (with VPC)
- EKS/ECS deployments
- DevSecOps integration (Trivy, Checkov)
- Cost monitoring setup

## Pricing Example
- Starter: $500 (Terraform + CI/CD)
- Growth: $1,000 (Add Security & EKS)
- Pro: $1,800 (Full Infra + FinOps)

## Roadmap
- Add ALB + WAF + CloudTrail logging

## Contact
📧 **sumanthnallandhigal@gmail.com**  
🌐 AWS Partner Profile (placeholder)  
🔗 LinkedIn (placeholder)

## License
MIT — see `LICENSE`.


