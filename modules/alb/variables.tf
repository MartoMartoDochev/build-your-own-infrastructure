variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "sg_id" {}

variable "log_bucket" {
  description = "S3 bucket to store ALB logs"
  type        = string
}

variable "alb_name" {
  description = "Name for the Application Load Balancer"
  type        = string
}