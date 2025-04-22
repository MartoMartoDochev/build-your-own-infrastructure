
variable "alb_name" {
  type = string
}

variable "rds_identifier" {
  type = string
}

variable "log_bucket_name" {
  type = string
}

variable "notification_topic" {
  type = string
}

variable "asg_name" {
    type = string
}

variable "scale_out_policy_arn" {
  type        = string
  description = "ARN of the scale-out policy"
}

variable "scale_in_policy_arn" {
  type        = string
  description = "ARN of the scale-in policy"
}