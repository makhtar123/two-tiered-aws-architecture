output "alb_dns_name" {
  description = "Public DNS name of the application load balancer"
  value       = module.load_balancer.alb_dns_name
}

output "launch_template_id" {
  description = "Application launch template ID"
  value       = module.compute.launch_template_id
}
