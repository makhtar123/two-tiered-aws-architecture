resource "aws_security_group" "allow_alb" {
  name        = var.application_security_group_name
  description = "Allow inbound traffic from alb and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.allow_alb.id
  referenced_security_group_id = var.alb_security_group_id
  from_port                    = var.application_port
  to_port                      = var.application_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_traffic_private_sub" {
  security_group_id = aws_security_group.allow_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ubuntu_ami_owner]

  filter {
    name   = "name"
    values = [var.ubuntu_ami_name_pattern]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_iam_instance_profile" "ec2_ssm" {
  name = var.iam_instance_profile_name
}

resource "aws_launch_template" "app" {
  name_prefix            = var.launch_template_name_prefix
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  update_default_version = true

  vpc_security_group_ids = [aws_security_group.allow_alb.id]
  user_data              = var.rendered_user_data

  iam_instance_profile {
    arn = data.aws_iam_instance_profile.ec2_ssm.arn
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform-app"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name_prefix         = var.autoscaling_group_name_prefix
  desired_capacity    = var.desired_capacity
  min_size            = var.minimum_capacity
  max_size            = var.maximum_capacity
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period
  min_elb_capacity          = var.minimum_elb_capacity

  tag {
    key                 = "Name"
    value               = "app-server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "request_count" {
  name                      = "request-count-target"
  autoscaling_group_name    = aws_autoscaling_group.app.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = var.instance_warmup

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.alb_arn_suffix}/${var.target_group_arn_suffix}"
    }

    target_value = var.requests_per_target
  }
}
