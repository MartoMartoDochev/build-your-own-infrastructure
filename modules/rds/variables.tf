variable "db_name" {
  default = "wordpress"
}
variable "db_username" {}
variable "db_password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true
}
variable "db_instance_class" {}

variable "rds_sg_id" {
  description = "Security group ID to allow DB access from EC2"
  type        = string
}
variable "multi_az" {
  type    = bool
  default = true
}


variable "vpc_id" {}

variable "subnet_ids" {
  type = list(string)
}

variable "monitoring_role_arn" {
  description = "IAM Role ARN used for enhanced RDS monitoring"
  type        = string
}