output "public_ip" {
  value = join(", ", aws_eip.eip.*.public_ip)
}

output "private_ip_trn" {
  value = join(", ", aws_eip.eip.*.private_ip)
}

output "psql_address" {
  value = aws_db_instance.devops_service_rds_instance.address
}