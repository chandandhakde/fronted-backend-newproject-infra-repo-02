# resource "aws_security_group" "vpc_sg" {
#     vpc_id = aws_vpc.this_vpc.id
#     tags = {
#       Name = "${var.org}_${var.lob}_${var.env}_security_group_01"
#     }
# }

resource "aws_security_group" "alb_sg" {
  name = "security-group-alb-02"
  vpc_id = aws_vpc.this_vpc.id
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 

  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.org}_${var.lob}_${var.env}_security_group_alb_02"
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "security-group-ecs-03"
  vpc_id = aws_vpc.this_vpc.id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

   ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # # ADD THIS — ephemeral ports for bridge mode dynamic mapping
  # ingress {
  #   from_port       = 32768
  #   to_port         = 65535
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # restrict to your IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.org}_${var.lob}_${var.env}_security_group_ecs_03"
  }
}
