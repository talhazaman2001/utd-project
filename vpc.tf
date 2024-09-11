# VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}

# Identify the CIDR ranges for the 3 Public Subnets
variable "public_subnet_cidrs" {
    type = list(string)
    description = "Public Subnet CIDR Values"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = element(var.public_subnet_cidrs, count.index)
    tags = {
        Name = "Public Subnet ${count.index + 1}"
    }
}

# Identify the CIDR ranges for the 3 Private Subnets
variable "private_subnet_cidrs" {
    type = list(string)
    description = "Private Subnet CIDR Values"
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = element(var.private_subnet_cidrs, count.index)
    tags ={
        Name = "Private Subnet ${count.index + 1}"
    }
}

# Store the list of Availability Zones
variable "azs" {
    type = list(string)
    description = "Availability Zones"
    default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

# Map the Public Subnets to the Availability Zones
resource "aws_subnet" "public_subnets" {
    count             = length(var.public_subnet_cidrs)
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = element(var.public_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)
 
    tags = {
    Name = "Public Subnet ${count.index + 1}"
 }
}

# Map the Private Subnets to the Availability Zones
resource "aws_subnet" "private_subnets" {
    count             = length(var.private_subnet_cidrs)
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = element(var.private_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)
 
    tags = {
    Name = "Private Subnet ${count.index + 1}"
 }
}
# IGW for Public Subnets
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
} 

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rt-assoc" {
    count = lenght(var.public_subnet_cidrs)
    subnet_id = element(aws_subnet.public_subnets.id[*], count.index)
    route_table_id = aws_route_table.public_rt.id
}

# Add Route to Public Route Table (internet access)
resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}


