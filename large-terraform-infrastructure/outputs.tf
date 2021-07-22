# output "public_ip" {
#   value = join(", ", aws_eip.eip.*.public_ip)
# }

# output "private_ip_transcoder" {
#   value = join(", ", aws_eip.eip.*.private_ip)
# }

# output "psql_address" {
#   value = aws_db_instance.octopus_rds_instance.address
# }

output "s3_buckets"{
  value = values(aws_s3_bucket.s3bucket)[*].bucket
}