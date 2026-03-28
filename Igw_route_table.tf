resource "aws_internet_gateway" "this_igw" {
    vpc_id = aws_vpc.this_vpc.id
    tags = {
      Name = "${var.org}_${var.lob}_${var.env}_igw"
    }
  
}



resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.this_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this_igw.id
    }

    tags = {
      Name = "${var.org}_${var.lob}_${var.env}_pub_rt"
    }
}

resource "aws_route_table_association" "sub_1a" {
    subnet_id = aws_subnet.this_pub_sub_01.id
    route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "sub_1b" {
    subnet_id = aws_subnet.this_pub_sub_02.id
    route_table_id = aws_route_table.pub_rt.id
}