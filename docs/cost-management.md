# Cost Management

Pragmatic FinOps practices to control spend.

## Budgets & Alerts
- Use AWS Budgets or CloudWatch EstimatedCharges alarms
- `scripts/cost-alerts.py` creates SNS-backed billing alarms

## Tagging
- Enforce cost allocation tags: Project, Environment, Owner
- Report by tag in Cost Explorer

## Cleanup
- Use `scripts/cleanup.sh` to destroy test resources
- Lifecycle policies for ECR and S3 where applicable

## Optimization Ideas
- Right-size compute, use Savings Plans/RIs
- Prefer Fargate for spiky workloads; spot where appropriate
- Use autoscaling and schedule-based scaling
