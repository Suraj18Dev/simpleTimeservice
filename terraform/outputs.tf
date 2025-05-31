output "load_balancer_dns" {
  description = "Access your app at this URL"
  value       = aws_lb.app_alb.dns_name
}
