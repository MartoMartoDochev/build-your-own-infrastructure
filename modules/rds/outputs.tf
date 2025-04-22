output "db_instance_id" {
  value = aws_db_instance.wordpress.id
}

output "endpoint" {
  value = aws_db_instance.wordpress.endpoint
}

output "address" {
  value = aws_db_instance.wordpress.address
}

