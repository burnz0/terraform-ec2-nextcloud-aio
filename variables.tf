# Define your AWS region
variable "aws_region" {
  description = "The AWS region where resources will be created."
  default     = "eu-central-1"
}

variable "app_name" {
  type        = string
  description = "A unique name for this application"
  default     = "gfl-nextcloud-aio"
}

# Define the description for the security group
variable "security_group_description" {
  description = "Description for the security group."
  default     = "Security group for Nextcloud EC2 instance"
}

# Define the CIDR blocks for ingress rules
variable "ingress_cidr_blocks" {
  description = "CIDR blocks for ingress rules."
  default     = ["0.0.0.0/0"]
}

# Define your EC2-related variables here, such as EC2 AMI, instance type, key name, etc.
variable "ec2_ami_id" {
  type    = string
  default = "ami-066e46ed5f3d49b2c" # Amazon Linux AMI amzn-ami-2018.03.20230929 x86_64 ECS HVM GP2
}

variable "ec2_instance_type" {
  type    = string
  default = "t3a.xlarge"
}

variable "ec2_key_name" {
  type    = string
  default = "nextcloud-aio"
}

variable "hosted_zone" {
  type        = string
  description = "Route 53 hosted zone"
  default     = "dev.mydomain.cloud"
}


variable "dns_record_name" {
  type        = string
  description = "datalytics-suite DNS record name"
  default     = "share"
}

variable "domain" {
  type        = string
  description = "datalytics-suite DNS domain"
  default     = "dev.mydomain.cloud"
}

variable "load_balancer_is_internal" {
  type    = bool
  default = false
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}

variable "artifact_bucket_path" {
  type        = string
  default     = "/"
  description = "The path within the bucket where datalytics-suite will store its artifacts"
}
