resource "aws_vpc" "this_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
      Name = "${var.org}_${var.lob}_${var.env}_vpc_01"
    }
  
}

# resource "aws_flow_log" "vpc_flow_log" {
#   vpc_id = aws_vpc.this_vpc.id
#   traffic_type = "ALL"
#   log_destination = aws_cloudwatch_log_group.vpc_logs.arn
# }