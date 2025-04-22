variable "az_count" {
  description = "Number of availability zones"
  type        = number
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}