output "instance_profile_name" {
  value = aws_iam_instance_profile.profile.name
}

output "rds_monitoring_role" {
  value = aws_iam_role.rds_monitoring.arn
}