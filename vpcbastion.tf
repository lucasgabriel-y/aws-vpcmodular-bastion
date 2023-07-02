
resource "aws_vpc" "bastion_vpc" {
  cidr_block = "192.168.0.0/16" # Bloco de endereços IP da VPC

  tags = {
    Name = "bastion-vpc"
  }
}

# Cria uma subnet pública
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.bastion_vpc.id
  cidr_block = "192.168.1.0/24" # Bloco de endereços IP da subnet
  availability_zone = "us-east-1a"
  tags = {
    Name = "public_subnet_a"
  }
}

# Cria um grupo de segurança para a subnet pública
resource "aws_security_group" "public_security_group" {
  name_prefix = "public_security_group"
  vpc_id      = aws_vpc.bastion_vpc.id

    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "public_security_group"
  }
}


resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Acesso"
  vpc_id      = aws_vpc.bastion_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "bastion_sg"
  }
}

# Cria um gateway de internet para a VPC
resource "aws_internet_gateway" "gateway_internet" {
  vpc_id = aws_vpc.bastion_vpc.id

  tags = {
    Name = "gateway_internet"
  }
}

# Cria uma rota para permitir o tráfego da subnet pública para a Internet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.bastion_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_internet.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associa a subnet pública com a tabela de rotas pública
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
