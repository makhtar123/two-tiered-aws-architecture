output "alb_arn" {
  value = aws_lb.lb.arn
}

output "alb_arn_suffix" {
  value = aws_lb.lb.arn_suffix
}

output "alb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.allow_http.id
}

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.target_group.arn_suffix
}
