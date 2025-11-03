# Infrastructure Guide

Terraform provisions the VPC, routing, security groups, ECS cluster, IAM, and alarms.

## Layout
- providers.tf, backend.tf: providers and remote state (S3 + DynamoDB)
- variables.tf: inputs for region, CIDRs, tags
- vpc.tf: VPC, subnets (public/private), IGW, NAT, routes, SGs
- main.tf: ECS cluster, IAM role, CloudWatch alarm
- outputs.tf: VPC/subnet/route table IDs, ECS and IAM outputs

## Usage
```
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

## Backend
Update `backend.tf` with your S3 bucket and DynamoDB table. State is encrypted and locked for safety.

## Extending
- Add ECS services/tasks or EKS modules
- Introduce module structure for multi-env (envs/dev, envs/prod)
