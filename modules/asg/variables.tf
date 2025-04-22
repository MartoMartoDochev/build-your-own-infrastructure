variable "subnet_ids" {
  type = list(string)
}
variable "launch_template_id" {}
variable "launch_template_version" {}
variable "target_group_arn" {}
variable "min_size" {}
variable "max_size" {}
variable "desired_capacity" {}

