output "alb_dns" {
  value = module.alb.dns_name
}

output "generated_db_password" {
  value     = random_password.db_password.result
  sensitive = true
}

output "db_endpoint" {
  value = module.rds.address
}

