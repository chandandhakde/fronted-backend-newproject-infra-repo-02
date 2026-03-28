output "vpc_id" {
    value = aws_vpc.this_vpc.id
}

output "sub_id_01" {
    value = aws_subnet.this_pub_sub_01.id
}

output "sub_id_02" {
    value = aws_subnet.this_pub_sub_02.id
}

output "rt_id" {
    value = aws_route_table.pub_rt.id
}

output "igw_id" {
    value = aws_internet_gateway.this_igw.id
}

output "ecs_sg" {
    value = aws_security_group.ecs_sg.id
}

output "alb_sg" {
    value = aws_security_group.alb_sg.id
}

output "alb_DNS" {
    value = aws_lb.alb.dns_name
}

#launch template--------------------------------------------------
output "launch_template" {
    value = aws_launch_template.lt.id
}
output "launch_template_latest-version" {
    value = aws_launch_template.lt.latest_version
}

#asg-name---------------------------------------
output "ecs_asg_name" {
   value = aws_autoscaling_group.ecs_asg.name
}

#ecs-cluster-name-----------------------------
output "ecs_cluster_name" {
    value = aws_ecs_cluster.ecs_cluster.name
}
