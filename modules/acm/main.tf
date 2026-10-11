data "aws_route53_zone" "certificate_route53_zone" {
  name         = var.root_domain_name
  private_zone = false
}

resource "aws_acm_certificate" "certificate" {
  provider = aws.us_east_1
  domain_name               = var.root_domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = var.root_domain_name
    project = "karthik-portfolio"
  }
}

resource "aws_route53_record" "cert_dns" {
  for_each = {
    for domain in aws_acm_certificate.certificate.domain_validation_options : domain.domain_name => {
      name   = domain.resource_record_name
      record = domain.resource_record_value
      type   = domain.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.certificate_route53_zone.zone_id
}

resource "aws_acm_certificate_validation" "certificate" {
  provider = aws.us_east_1
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns : record.fqdn]
}