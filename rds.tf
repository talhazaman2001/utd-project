# RDS Subnet Group (Private Subnets)
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "rds-subnet-group"
    subnet_ids = aws_subnet.private_subnet[*].id

    tags = {
        Name = "rds-subnet-group"
    }
}

# RDS Instance
resource "aws_db_instance" "my_rds" {
    allocated_storage = 20
    engine = "postgres"
    engine_version = "16.3"
    instance_class = "db.t3.micro"
    username = "admin"
    password = "password123"
    parameter_group_name = "default.postgres16"
    publicly_accessible = false
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

    tags = {
        Name = "my-rds-instance"
    }

}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.my_rds.endpoint
}