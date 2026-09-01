variable "aws_region" {
  description = "AWS region in which to deploy the infrastructure."
  type        = string
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "Local AWS CLI profile Terraform uses for authentication."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag assigned to the VPC."
  type        = string
  default     = "terraform-vpc"
}

variable "availability_zone_1" {
  description = "First Availability Zone."
  type        = string
  default     = "us-east-2a"
}


variable "availability_zone_2" {
  description = "Second Availability Zone."
  type        = string
  default     = "us-east-2b"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet."
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet."
  type        = string
  default     = "10.0.3.0/24"
}

variable "default_route_cidr" {
  description = "Destination CIDR used by the default IPv4 routes."
  type        = string
  default     = "0.0.0.0/0"
}

variable "alb_ingress_cidr" {
  description = "IPv4 CIDR allowed to reach the public ALB listener."
  type        = string
  default     = "0.0.0.0/0"
}

variable "alb_name" {
  description = "Name assigned to the Application Load Balancer."
  type        = string
  default     = "terraform-alb"
}

variable "alb_security_group_name" {
  description = "Name assigned to the ALB security group."
  type        = string
  default     = "allow_hhtp"
}

variable "application_security_group_name" {
  description = "Name assigned to the application security group."
  type        = string
  default     = "allow_alb"
}

variable "listener_port" {
  description = "Public HTTP port exposed by the ALB listener."
  type        = number
  default     = 80
}

variable "application_port" {
  description = "Port used by the target group, application security group, and web server."
  type        = number
  default     = 8000
}

variable "target_group_name_prefix" {
  description = "Prefix used to generate a unique target group name."
  type        = string
  default     = "tfapp-"
}

variable "health_check_path" {
  description = "HTTP path used by the target group health check."
  type        = string
  default     = "/"
}

variable "health_check_healthy_threshold" {
  description = "Consecutive successful checks required for a target to become healthy."
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Consecutive failed checks required for a target to become unhealthy."
  type        = number
  default     = 3
}

variable "health_check_timeout" {
  description = "Target group health-check timeout in seconds."
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Time in seconds between target group health checks."
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "HTTP response codes considered healthy."
  type        = string
  default     = "200"
}

variable "deregistration_delay" {
  description = "Seconds the target group waits before deregistering a target."
  type        = number
  default     = 60
}

variable "ubuntu_ami_owner" {
  description = "AWS account ID that owns the Ubuntu AMIs."
  type        = string
  default     = "099720109477"
}

variable "ubuntu_ami_name_pattern" {
  description = "Name pattern used to select the latest Ubuntu AMI."
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "instance_type" {
  description = "EC2 instance type used by the launch template."
  type        = string
  default     = "t3.micro"
}

variable "iam_instance_profile_name" {
  description = "Existing IAM instance profile attached to EC2 instances."
  type        = string
  default     = "EC2-SSM"
}

variable "launch_template_name_prefix" {
  description = "Prefix used to generate the launch template name."
  type        = string
  default     = "terraform-app-"
}

variable "autoscaling_group_name_prefix" {
  description = "Prefix used to generate the Auto Scaling group name."
  type        = string
  default     = "app-"
}

variable "desired_capacity" {
  description = "Initial desired number of application instances."
  type        = number
  default     = 3
}

variable "minimum_capacity" {
  description = "Minimum number of application instances."
  type        = number
  default     = 2
}

variable "maximum_capacity" {
  description = "Maximum number of application instances."
  type        = number
  default     = 4
}

variable "health_check_grace_period" {
  description = "Seconds Auto Scaling ignores health-check failures for new instances."
  type        = number
  default     = 300
}

variable "minimum_elb_capacity" {
  description = "Minimum healthy ELB target capacity Terraform waits for during ASG creation."
  type        = number
  default     = 2
}

variable "instance_warmup" {
  description = "Seconds a new instance warms up before contributing to scaling metrics."
  type        = number
  default     = 300
}

variable "requests_per_target" {
  description = "Desired ALB request count per target used by target-tracking scaling."
  type        = number
  default     = 500.0
}
