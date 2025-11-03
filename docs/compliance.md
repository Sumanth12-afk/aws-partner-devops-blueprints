# Compliance

This project helps align to CIS AWS Foundations Benchmark and AWS FSBP.

## Mappings (Examples)
- Network segmentation: VPC public/private subnets, SG restrictions
- Logging & monitoring: CloudWatch metrics/alarms
- Least privilege: scoped IAM roles for CI/CD and runtime
- IaC policy checks: Checkov with Terraform framework

## Evidence
- Store pipeline scan reports (Trivy/Checkov) as artifacts
- Keep Terraform state and change history under version control

## Exceptions
- Document any deviations with owner, rationale, and review date
