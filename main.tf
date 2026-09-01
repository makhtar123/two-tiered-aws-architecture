locals {
  rendered_user_data = base64encode(templatefile(
    "${path.module}/templates/user-data.sh.tftpl",
    {
      html_content = file("${path.module}/templates/index.html")
      app_port     = var.application_port
    }
  ))
}

module "network" {
  source = "./modules/network"

  vpc_cidr              = var.vpc_cidr
  vpc_name              = var.vpc_name
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  default_route_cidr    = var.default_route_cidr
}

module "load_balancer" {
  source = "./modules/load-balancer"

  vpc_id                           = module.network.vpc_id
  public_subnet_ids                = module.network.public_subnet_ids
  alb_name                         = var.alb_name
  alb_security_group_name          = var.alb_security_group_name
  alb_ingress_cidr                 = var.alb_ingress_cidr
  listener_port                    = var.listener_port
  application_port                 = var.application_port
  target_group_name_prefix         = var.target_group_name_prefix
  health_check_path                = var.health_check_path
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_timeout             = var.health_check_timeout
  health_check_interval            = var.health_check_interval
  health_check_matcher             = var.health_check_matcher
  deregistration_delay             = var.deregistration_delay
}

module "compute" {
  source = "./modules/compute"

  vpc_id                          = module.network.vpc_id
  private_subnet_ids              = module.network.private_subnet_ids
  alb_security_group_id           = module.load_balancer.alb_security_group_id
  target_group_arn                = module.load_balancer.target_group_arn
  alb_arn_suffix                  = module.load_balancer.alb_arn_suffix
  target_group_arn_suffix         = module.load_balancer.target_group_arn_suffix
  application_security_group_name = var.application_security_group_name
  application_port                = var.application_port
  ubuntu_ami_owner                = var.ubuntu_ami_owner
  ubuntu_ami_name_pattern         = var.ubuntu_ami_name_pattern
  instance_type                   = var.instance_type
  iam_instance_profile_name       = var.iam_instance_profile_name
  launch_template_name_prefix     = var.launch_template_name_prefix
  rendered_user_data              = local.rendered_user_data
  autoscaling_group_name_prefix   = var.autoscaling_group_name_prefix
  desired_capacity                = var.desired_capacity
  minimum_capacity                = var.minimum_capacity
  maximum_capacity                = var.maximum_capacity
  health_check_grace_period       = var.health_check_grace_period
  minimum_elb_capacity            = var.minimum_elb_capacity
  instance_warmup                 = var.instance_warmup
  requests_per_target             = var.requests_per_target
}
