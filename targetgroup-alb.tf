resource "aws_lb_target_group" "frontend_tg" {
    name = "frontend-tg"
    vpc_id = aws_vpc.this_vpc.id
    target_type = var.tg_type
    port = 3000 #change from 80
    protocol = "HTTP"
    health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200-399" 
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
    tags = {
      Name =  "${var.org}_${var.lob}_${var.env}_target_group_frontend_01"
  
    }
}


resource "aws_lb_target_group" "backend_tg" {
  name        = "backend-tg"
  vpc_id      = aws_vpc.this_vpc.id
  target_type = var.tg_type
  port        = 5000
  protocol    = "HTTP"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  tags = {
    Name = "${var.org}_${var.lob}_${var.env}_backend_tg_02"
  }
}

resource "aws_lb" "alb" {
    name = "alb"
    load_balancer_type = var.alb_type
    subnets = [ aws_subnet.this_pub_sub_01.id, aws_subnet.this_pub_sub_02.id ]
    security_groups = [ aws_security_group.alb_sg.id ]
    enable_deletion_protection = false
    tags = {
      Name =  "${var.org}_${var.lob}_${var.env}_alb_01"
  
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.frontend_tg.arn
    }
    tags = {
      Name = "ecs-col-listerner"
    }
}

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/enhance*"]
    }
  }
}
