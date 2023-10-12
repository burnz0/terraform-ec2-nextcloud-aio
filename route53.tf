resource "aws_route53_record" "nextcloud_aio_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "${var.dns_record_name}.${var.domain}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.ecs_eip.public_ip]
}

data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone
}