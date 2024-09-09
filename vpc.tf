# VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-west-2a"
    tags = {
        Name = "public-subnet"
    }
}

# Identify the CIDR ranges for the 3 Private Subnets
variable "private_subnet_cidrs" {
    type = list(string)
    description = "Private Subnet CIDR Values"
    default = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = element(var.private_subnet_cidrs, count.index)
    tags ={
        Name = "private-subnet"
    }
}

# Store the list of Availability Zones
variable "azs" {
    type = list(string)
    description = "Availability Zones"
    default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
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
# IGW for Public Subnet
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
} 

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rt-assoc" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

# Add Route to Public Route Table (internet access)
resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}


