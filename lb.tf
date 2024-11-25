resource "aws_lb" "KRK_LoadBalancer" {
  name               = "KRK-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.KRK_SecurityGroup_LB.id]
}

resource "aws_lb_target_group" "KRK_TargetGroup" {
  name     = "KRK-TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "KRK_Listener" {
  load_balancer_arn = aws_lb.KRK_LoadBalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.KRK_TargetGroup.arn
  }
}
