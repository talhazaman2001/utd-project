# Security Group for RDS (allow MySQL traffic)
resource "aws_security_group" "rds_sg" {
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"] # Allow from VPC only
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "rds-sg"
    }
}

#Security Group for Backend (EC2) to allow DB connection
resource "aws_security_group" "backend_sg" {
    vpc_id = aws_vpc.my_vpc.id
    
    egress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"] # Outbound to private subnets
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "backend-sg"
    }
}
