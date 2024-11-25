variable "vpc_id" {
  description = "The ID of the VPC where resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs associated with the VPC"
  type        = list(string)
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instances"
  type        = string
}