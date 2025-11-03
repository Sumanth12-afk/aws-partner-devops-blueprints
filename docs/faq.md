# FAQ

## Can I use this without Kubernetes?
Yes. ECS-only is supported and can be expanded later.

## How do I pass secrets securely?
Use GitHub Actions secrets and/or AWS Secrets Manager; avoid plaintext in code.

## What regions are supported?
All commercial AWS regions; update `var.region` and backend settings.

## Can we add staging and production?
Yes. Introduce per-env state and variables, or Terraform workspaces.

## Do you support WAF/ALB/CloudTrail?
Planned in the roadmap; can be added to Terraform modules.
