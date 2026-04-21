resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_attach" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#  (ECR permission)
resource "aws_iam_role_policy_attachment" "ecs_ecr_access" {
  #role       = aws_iam_role.ecs_instance_role.name
  role = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


resource "aws_iam_instance_profile" "ecs_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    # ✅ Change from amzn2 → al2023
    values = ["al2023-ami-ecs-hvm-*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}   

resource "aws_launch_template" "lt" {
    name = "dev-ecs-lt"
    image_id = data.aws_ami.ecs_ami.id
    instance_type = "m7i-flex.large"
    key_name = var.key_pair_lt

    # ✅ ADD THIS BLOCK — enables public IP on ASG-launched instances
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ecs_sg.id]
    delete_on_termination       = true
  }

    #vpc_security_group_ids = [ aws_security_group.ecs_sg.id ]

    iam_instance_profile {
      name = aws_iam_instance_profile.ecs_profile.name
    }
    user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
# AL2023 uses dnf instead of yum
dnf install -y ec2-instance-connect
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name = "col-lms-ecs-asg-01"
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [ aws_subnet.this_pub_sub_01.id, aws_subnet.this_pub_sub_02.id ]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  tag {
  key                 = "Name"
  value               = "ecs-instance"
  propagate_at_launch = true
}
}

  
