#############################[ PROVIDER ]################################################
provider "aws" {
  region = "us-east-1"
}
#############################[ VPC]################################################
resource "aws_vpc" "VPC1" {
  cidr_block       = var.vpc-cidr

  tags = {
    Name = var.vpc-name
  }
}
#############################[ INTERNET GATEWAY ]################################################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VPC1.id

  tags = {
    Name = var.IG
  }
}

#############################[ PUBLIC SUBNET ]################################################
resource "aws_subnet" "pubsubnets" {
  vpc_id     = aws_vpc.VPC1.id
  count = length(var.cidr_pub)
  availability_zone = var.pub_az[count.index]
  cidr_block = var.cidr_pub[count.index]

  
  tags = {
    Name = "ninja-pub-sub-${count.index}"
  }
}

#############################[ PUBLIC ROUTE TABLE CREATION AND ASSOCIATION ]################################################
resource "aws_route_table" "route-table" {
   vpc_id = aws_vpc.VPC1.id
   route {
     cidr_block = var.rt_ip
     gateway_id = aws_internet_gateway.gw.id
   }
   tags = {
     Name = var.rt_name
   }
 }


resource "aws_route_table_association" "connection-RT-subnet" {

  count = length(aws_subnet.pubsubnets)
  subnet_id      = element(aws_subnet.pubsubnets[*].id,count.index)
  route_table_id = aws_route_table.route-table.id
}

#############################[ PRIVATE SUBNET]################################################
  resource "aws_subnet" "pirsubnets" {
  vpc_id     = aws_vpc.VPC1.id
  count = length(var.cidr_pir)
  availability_zone = var.pir_az[count.index]
  cidr_block = var.cidr_pir[count.index]

  
  tags = {
    Name = "ninja-priv-sub-${count.index}"
  }
}

#############################[ ELASTIC IP CREATION ]################################################

resource "aws_eip" "natgateway" {
 domain = "vpc"
}


#############################[ NAT GATEWAY CREATION ]################################################
resource "aws_nat_gateway" "natgateway" {
  allocation_id     = aws_eip.natgateway.id
  connectivity_type = var.nat_type
  subnet_id         = aws_subnet.pubsubnets[0].id

  tags ={
    Name= var.nat-name
  }

}

#############################[ PRIVATE ROUTE TABLE CREATION AND ASSOCIATION ]################################################
resource "aws_route_table" "pir-route-table" {
   vpc_id = aws_vpc.VPC1.id
   count=1
    route {
     cidr_block = var.pvt_rt_ip
     nat_gateway_id = element(aws_nat_gateway.natgateway[*].id,count.index)
  
   }
   tags = {
     Name = var.pir-rt-name
   }
   
 }

resource "aws_route_table_association" "connection-RT-pir-subnet" {
  #count = length(aws_subnet.pirsubnets)
  count = length(aws_subnet.pirsubnets)
  subnet_id         = element(aws_subnet.pirsubnets[*].id,count.index)

  route_table_id = aws_route_table.pir-route-table[0].id
}

 #############################[ SECURITY GROUP  ]################################################ 
resource "aws_security_group" "ninja-SG" {
  name        = var.sg
  vpc_id      = aws_vpc.VPC1.id
  ingress {
    from_port   = var.sg_port
    to_port     = var.sg_port
    protocol    = var.sg_protocol
    cidr_blocks = [var.sg_cidr]
  }

  tags = {
    Name = var.sg
  }
}
#############################[ BESTION HOST ]################################################

resource "aws_instance" "bestion" {
  count                         = length(aws_subnet.pubsubnets)
  ami                           = var.ami_type
  instance_type                 = var.ec2_type
  key_name                      = var.key
  subnet_id                     = element(aws_subnet.pubsubnets[*].id, count.index)
  associate_public_ip_address   = true
  security_groups = [aws_security_group.ninja-SG.id]

  tags = {
   Name = var.bestion

  }
}

#############################[ PRIVATE_INSTANCES ]################################################
resource "aws_instance" "private_instance" {
  count                         = length(aws_subnet.pirsubnets)
  ami                           = var.ami_type
  instance_type                 = var.ec2_type
  key_name                      = var.key
  subnet_id                     = element(aws_subnet.pirsubnets[*].id, count.index)
  security_groups               = [aws_security_group.ninja-SG.id] 
  tags = {
   Name = var.pub_instance

  }
}

