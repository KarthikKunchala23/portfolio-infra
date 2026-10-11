output "certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}

output "route53_zone_id" {
  value = data.aws_route53_zone.certificate_route53_zone.zone_id
}

output "domain_validation_options" {
  value = aws_acm_certificate.certificate.domain_validation_options
}

output "validation_records" {
  value = [for record in aws_route53_record.cert_dns : record.fqdn]
}