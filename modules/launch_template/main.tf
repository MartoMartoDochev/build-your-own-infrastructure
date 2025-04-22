resource "aws_launch_template" "lt" {
  name_prefix   = "wordpress-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(var.user_data)

  network_interfaces {
    security_groups = [var.sg_id]
  }
}

