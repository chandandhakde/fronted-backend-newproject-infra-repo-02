resource "aws_ecs_cluster" "ecs_cluster" {
    name = "coltech_ecs_cluster_01"
    setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#this role allow ecs to pull container image, sends logs to the cloudwatch
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#this role is used inside the containcer...
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "login-task"
  requires_compatibilities = ["EC2"]
  network_mode             =  var.task_def_network_mode   
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = file("${path.module}/container-definition.json")
}

resource "aws_ecs_task_definition" "backend_task" {
  family                   = "backend-task"
  requires_compatibilities = ["EC2"]
  network_mode             = var.task_def_network_mode
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = file("${path.module}/backend-container.json")
}


resource "aws_ecs_service" "frontend_service" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  desired_count   = 1
  #launch_type     = "EC2"

capacity_provider_strategy {
 capacity_provider = aws_ecs_capacity_provider.ecs_cp.name
   weight            = 1
  }
  network_configuration {
    subnets = [ aws_subnet.this_pub_sub_01.id, aws_subnet.this_pub_sub_02.id ]
    security_groups = [ aws_security_group.ecs_sg.id ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "frontend-container"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.listener
  ]
}


resource "aws_ecs_service" "backend_service" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_cp.name
    weight            = 1
  }

  network_configuration {
    subnets         = [aws_subnet.this_pub_sub_01.id, aws_subnet.this_pub_sub_02.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_tg.arn
    container_name   = "backend-container"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.listener]
}




