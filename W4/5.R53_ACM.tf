## Route53
data "aws_route53_zone" "kyeongseixyz" {
#   zone_id = "Z0277820BLNPIVTX5T3W" ##두개 중복안됌
  name    = "kyeongsei.xyz."
}

##https://blog.outsider.ne.kr/1398
##(선행 작업) route 53에 호스팅 영역이 등록되어 있어야 함
##https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
##https://scbyun.com/916
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation

resource "aws_acm_certificate" "kyeongseixyz" {    
    domain_name       = "*.kyeongsei.xyz"
    validation_method = "DNS"

    subject_alternative_names = [ "kyeongsei.xyz", "www.kyeongsei.xyz" ]
    # validation_option {
    #     domain_name       = "*.kyeongsei.xyz"
    #     validation_domain = "kyeongsei.xyz"
    # }
    lifecycle {
        create_before_destroy = true
    }
    tags = {
        Name = format(
            "%s-%s-%s-acm",
            var.title,var.environments,var.subtitle
        )
    }    
}

resource "aws_route53_record" "kyeongseixyz" {
  for_each = {
    for dvo in aws_acm_certificate.kyeongseixyz.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.kyeongseixyz.zone_id
}

resource "aws_acm_certificate_validation" "kyeongseixyz" {
  certificate_arn         = aws_acm_certificate.kyeongseixyz.arn
  validation_record_fqdns = [for record in aws_route53_record.kyeongseixyz : record.fqdn]
}
