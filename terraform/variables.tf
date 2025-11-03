variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project identifier used for naming and tagging"
  type        = string
  default     = "aws-partner-devops-showcase"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnets" {
  description = "Private subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]
}

variable "availability_zones" {
  description = "Availability zones to place subnets in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default = {
    Project   = "aws-partner-devops-showcase"
    ManagedBy = "Terraform"
  }
}


