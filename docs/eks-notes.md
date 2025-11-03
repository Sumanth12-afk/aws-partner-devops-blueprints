# EKS Notes

Guidance for extending this repo with EKS.

## Prerequisites
- EKS cluster and node groups (or Fargate profiles)
- AWS Load Balancer Controller installed

## IRSA
- Create IAM roles for service accounts for least-privilege pod access
- Annotate ServiceAccount with role ARN

## Ingress
- `k8s/ingress.yaml` uses `kubernetes.io/ingress.class: alb`
- Configure listeners, SSL, and WAF via annotations

## Upgrades
- Plan Kubernetes version upgrades; upgrade node groups first, then controllers
- Validate with canary Deployments and HPA settings
