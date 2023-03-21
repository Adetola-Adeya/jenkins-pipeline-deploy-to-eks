# Route 53 and sub-domain name setup

resource "aws_route53_zone" "web" {
  name = "web.oxlava.tech"
}

resource "aws_route53_zone" "socks-web" {
  name = "socks.oxlava.tech"
}

# Get the zone_id for the load balancer

data "aws_elb_hosted_zone_id" "elb_zone_id" {
  depends_on = [
    kubernetes_service.web-service, kubernetes_service.kube-service-socks
  ]
}

# DNS record for portfolio

resource "aws_route53_record" "portfolio-record" {
  zone_id = aws_route53_zone.web.zone_id
  name    = "web.oxlava.tech"
  type    = "A"

  alias {
    name                   = kubernetes_service.web-service.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.elb_zone_id.id
    evaluate_target_health = true
  }
}

# DNS record for socks

resource "aws_route53_record" "socks-record" {
  zone_id = aws_route53_zone.socks-web.zone_id
  name    = "socks.oxlava.tech"
  type    = "A"

  alias {
    name                   = kubernetes_service.kube-service-socks.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.elb_zone_id.id
    evaluate_target_health = true
  }
}

## Run terraform outout, takes longer to propagate
output "web_nameservers" {
  value = aws_route53_zone.web.name_servers
}

output "socks_nameservers" {
  value = aws_route53_zone.socks-web.name_servers
}
