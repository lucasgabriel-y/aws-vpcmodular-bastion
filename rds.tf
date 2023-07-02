# Cria o grupo de segurança para o banco de dados
resource "aws_security_group" "db_security_group" {
  name        = "db-security-group"
  description = "Security group for the database"
  
  # Regras de entrada permitindo acesso ao banco de dados
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Regras de saída permitindo tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Cria a sub-rede para o banco de dados
resource "aws_subnet" "db_subnet" {
  vpc_id     = aws_vpc.apprds_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"
}

# Cria a sub-rede para o banco de dados
resource "aws_subnet" "db_subnet_b" {
  vpc_id     = aws_vpc.apprds_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"
}

# Cria a instância do banco de dados RDS
resource "aws_db_instance" "db_instance" {
  allocated_storage    = 100
  engine               = "mariadb"
  engine_version       = "10.4"
  instance_class       = "db.t2.micro"
  multi_az             = true
  identifier           = "instancia-db"
  username             = "admin"
  password             = "password123"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  skip_final_snapshot    = true

  # Configurações de backup
  backup_retention_period = 7
  backup_window           = "23:00-00:00"
  maintenance_window      = "Mon:03:00-Mon:04:00"

}

# Cria o grupo de sub-redes para o banco de dados
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.db_subnet.id, aws_subnet.db_subnet_b.id]
}

output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}
