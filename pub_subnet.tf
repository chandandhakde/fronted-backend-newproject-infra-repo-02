resource "aws_subnet" "this_pub_sub_01" {
    vpc_id = aws_vpc.this_vpc.id
    cidr_block = var.cidr_block_01
    availability_zone = var.sub_azs_1a
    map_public_ip_on_launch = var.pub_ip_true
    tags = {
      Name =  "${var.org}_${var.lob}_${var.env}_pub_sub_01"
  
}
}

resource "aws_subnet" "this_pub_sub_02" {
    vpc_id = aws_vpc.this_vpc.id
    cidr_block = var.cidr_block_02
    availability_zone = var.sub_azs_1b
    map_public_ip_on_launch = var.pub_ip_true
    tags = {
      Name = "${var.org}_${var.lob}_${var.env}_pub_sub_02"
    }
  
}

