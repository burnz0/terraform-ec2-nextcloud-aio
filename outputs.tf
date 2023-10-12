# URLs for Nextcloud setup
output "vpc_id" {
  value = aws_vpc.nextcloud_aio_vpc.id
}

output "eip_setup_uri" {
  value = "https://${aws_eip.ecs_eip.public_ip}:8080"
}

output "nextcloud_setup_uri" {
  value = "https://${var.dns_record_name}.${var.domain}:8080"
}
output "nextcloud_uri" {
  value = "https://${var.dns_record_name}.${var.domain} (after setup is done)"
}
