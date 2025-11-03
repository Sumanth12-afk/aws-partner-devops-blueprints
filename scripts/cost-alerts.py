#!/usr/bin/env python3
"""
Create an AWS CloudWatch billing alarm and SNS topic for monthly EstimatedCharges.

Requirements:
- boto3 (`pip install boto3`)
- AWS credentials configured (env vars or shared config)

Usage:
  python scripts/cost-alerts.py --threshold 100 --email you@example.com --region us-east-1
Notes:
- Billing metrics are only available in us-east-1.
"""

import argparse
import sys
import boto3


def ensure_topic(sns, name: str, email: str) -> str:
    topic_arn = sns.create_topic(Name=name)["TopicArn"]
    # Subscribe email if provided
    if email:
        subs = sns.list_subscriptions_by_topic(TopicArn=topic_arn).get("Subscriptions", [])
        if not any(s.get("Endpoint") == email for s in subs):
            sns.subscribe(TopicArn=topic_arn, Protocol="email", Endpoint=email)
    return topic_arn


def put_billing_alarm(cw, threshold: float, topic_arn: str):
    cw.put_metric_alarm(
        AlarmName="EstimatedCharges-Monthly-USD",
        AlarmDescription="Alarm when monthly AWS estimated charges exceed threshold",
        Namespace="AWS/Billing",
        MetricName="EstimatedCharges",
        Dimensions=[{"Name": "Currency", "Value": "USD"}],
        Statistic="Maximum",
        Period=21600,  # 6 hours
        EvaluationPeriods=1,
        Threshold=threshold,
        ComparisonOperator="GreaterThanOrEqualToThreshold",
        TreatMissingData="notBreaching",
        AlarmActions=[topic_arn] if topic_arn else [],
        OKActions=[topic_arn] if topic_arn else [],
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--threshold", type=float, default=100.0, help="USD threshold for monthly estimated charges")
    parser.add_argument("--email", type=str, default="", help="Notification email for SNS subscription")
    parser.add_argument("--region", type=str, default="us-east-1", help="Region for API calls (billing metrics are in us-east-1)")
    args = parser.parse_args()

    session = boto3.Session(region_name=args.region)
    sns = session.client("sns")
    cw = session.client("cloudwatch", region_name="us-east-1")

    topic_arn = ensure_topic(sns, "aws-cost-alerts", args.email)
    put_billing_alarm(cw, args.threshold, topic_arn)
    print(f"Created/updated billing alarm at threshold ${args.threshold} with SNS topic {topic_arn}")


if __name__ == "__main__":
    sys.exit(main())


