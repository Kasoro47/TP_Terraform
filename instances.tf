resource "aws_launch_template" "KRK_launch_template" {
  name          = "KRK_Web_Launch_Template"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.KRK_SecurityGroup_EC2.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "KRK_Web_Instance"
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
              echo "<h1>Instance ID: $INSTANCE_ID</h1>" > /var/www/html/index.html
              EOF
  )
}

resource "aws_autoscaling_group" "KRK_Asg" {
  name                = "KRK_asg"
  desired_capacity    = 2
  max_size           = 4
  min_size           = 1
  target_group_arns  = [aws_lb_target_group.KRK_TargetGroup.arn]
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.KRK_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "KRK_Asg_Instance"
    propagate_at_launch = true
  }
}