output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app.name
}

output "application_security_group_id" {
  value = aws_security_group.allow_alb.id
}
