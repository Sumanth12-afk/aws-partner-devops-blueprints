# Operations Runbooks

Common operational tasks for the platform.

## Scaling ECS Service
- Update desired count via console or CLI
- For EKS, scale Deployment replicas

## Rotating Secrets
- Rotate in Secrets Manager / GitHub
- Trigger redeploy (ECS force-new-deployment)

## Rolling Back
- Redeploy previous image tag in ECS service
- Revert last Terraform change (plan then apply)

## Log Triage
- Check CloudWatch Logs groups for ECS/EKS
- Use filter patterns for errors/timeouts

## Network Issues
- Verify SG rules and route tables
- Confirm NAT/IGW health
