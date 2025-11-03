terraform {
  # Remote backend for collaborative state and state locking.
  # NOTE: Replace placeholders with your actual S3 bucket and DynamoDB table names.
  backend "s3" {
    bucket         = "your-tf-state-bucket"      # e.g., aws-partner-devops-state
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-1"                  # Backend region must be static
    dynamodb_table = "your-tf-locks-table"       # e.g., aws-partner-devops-locks
    encrypt        = true
  }
}


