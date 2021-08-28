# provider 지정(AWS)
provider "aws" {
    region = var.region
}

# VPC 생성
resource "aws_vpc" "ELK_VPC" {
    cidr_block = "${var.cidr_block["cidr_vpc"]}"
    tags = {
        Name = "ELK_VPC"
    }
  
}

# Subnet 생성
resource "aws_subnet" "ELK_public" {
    vpc_id = "${aws_vpc.ELK_VPC.id}"
    cidr_block = "${var.cidr_block["cidr_subnet"]}"
    availability_zone = "ap-northeast-2a"
    tags = {
        Name = "ELK_subnet"
    }
}

# Internet Gateway 생성
resource "aws_internet_gateway" "ELK_IGW" {
    vpc_id = "${aws_vpc.ELK_VPC.id}"
    tags = {
        Name = "ELK_IGW"
    }
}

# eip 생성
resource "aws_eip" "ELK_EIP" {
    tags = {
        Name = "ELK_EIP"
    } 
}

# Routing table 생성
resource "aws_route_table" "ELK_route" {
    vpc_id = "${aws_vpc.ELK_VPC.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ELK_IGW.id
    }
    tags = {
      "Name" = "ELK_route"
    }
}

# Routing table에 subnet 추가
resource "aws_route_table_association" "ELK_route_subnet" {
    subnet_id = aws_subnet.ELK_public.id
    route_table_id = aws_route_table.ELK_route.id
}

# ELK_SG 생성
resource "aws_security_group" "ELK_SG" {
    vpc_id = "${aws_vpc.ELK_VPC.id}"
    tags = {
        Name = "ELK_SG"
    }
}

# Outbound 규칙 추가
resource "aws_security_group_rule" "ELK_outbound" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.ELK_SG.id
}

# Inbound 22 규칙 추가
resource "aws_security_group_rule" "ELK_Inbound" {
    type                = "ingress"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.ELK_SG.id
}

# Inbound 9200 규칙 추가
resource "aws_security_group_rule" "ELK_Inbound_9200" {
    type                = "ingress"
    from_port           = 9200
    to_port             = 9200
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.ELK_SG.id
}

# Inbound 5044 규칙 추가
resource "aws_security_group_rule" "ELK_Inbound_5044" {
    type                = "ingress"
    from_port           = 5044
    to_port             = 5044
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.ELK_SG.id
}

# Inbound 5601 규칙 추가
resource "aws_security_group_rule" "ELK_Inbound_5601" {
    type                = "ingress"
    from_port           = 5601
    to_port             = 5601
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.ELK_SG.id
}

# key pair 생성
resource "aws_key_pair" "ELK_key" {
    key_name = "ELK_key"
    public_key = "${file("C:/Users/ssy40/.ssh/elk")}"

}


# EC2 생성
resource "aws_instance" "ELK_terraform" {
    # Amazon linux2의 ami
    ami = var.ami
    instance_type = "t2.large"
    subnet_id = "${aws_subnet.ELK_public.id}"
    vpc_security_group_ids = ["${aws_security_group.ELK_SG.id}"]
    associate_public_ip_address = true
    key_name = "${aws_key_pair.ELK_key.key_name}"
    user_data = "${file("install.sh")}"
    tags = {
        Name = "ELK_terraform"
    }
}

resource "aws_eip_association" "ELK_eip_asso" {
    instance_id   = "${aws_instance.ELK_terraform.id}"
    allocation_id = "${aws_eip.ELK_EIP.id}"
}