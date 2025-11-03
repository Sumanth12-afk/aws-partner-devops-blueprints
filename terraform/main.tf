# -----------------------------
# Compute and Ops: ECS Cluster, IAM, CloudWatch Alarms
# -----------------------------

# ECS cluster as a placeholder for workloads. EKS can be wired similarly.
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, { Name = "${var.project_name}-ecs" })
}

# IAM role for ECS task execution (pulling images, CloudWatch logs)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action   = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Alarm: Average EC2 CPUUtilization across all instances using metric math SEARCH.
# This captures EC2 usage signal without referencing a specific instance id.
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "${var.project_name}-ec2-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 80
  datapoints_to_alarm = 2
  treat_missing_data  = "notBreaching"
  alarm_description   = "Average EC2 CPU >= 80% across the fleet"

  metric_query {
    id          = "m1"
    expression  = "SEARCH('{AWS/EC2,InstanceId} MetricName=\"CPUUtilization\"', 'Average', 300)"
    return_data = false
  }

  metric_query {
    id          = "e1"
    expression  = "AVG(METRICS())"
    label       = "Average EC2 CPU"
    return_data = true
  }

  alarm_actions = [] # Add SNS topic ARN(s) for notifications if desired
  ok_actions    = []

  tags = var.tags
}

# Note: Workloads (ECS services, tasks) would reference subnets and SGs from VPC.
# Example subnet/SG references available via outputs.


