# -----------------------------
# Networking: VPC, Subnets, IGW, NAT, Routes, SGs
# -----------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-vpc"
  })
}

# Internet Gateway for outbound traffic from public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-igw"
  })
}

# Public subnets across AZs
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => {
    cidr = cidr
    az   = var.availability_zones[idx]
  } }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-${each.key}"
    Tier = "public"
  })
}

# Private subnets across AZs
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => {
    cidr = cidr
    az   = var.availability_zones[idx]
  } }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-${each.key}"
    Tier = "private"
  })
}

# Elastic IP for single shared NAT Gateway (cost-effective)
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat-eip"
  })
}

# NAT gateway in the first public subnet to allow private subnets outbound internet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat"
  })

  depends_on = [aws_internet_gateway.igw]
}

# Public route table with route to Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private route table with default route to NAT gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-rt"
  })
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Security group for web tier (ingress 80/443 from internet)
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Web security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.project_name}-web-sg" })
}

# Security group for app tier (ingress 8080 from web_sg)
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "App security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description                = "App from web"
    from_port                  = 8080
    to_port                    = 8080
    protocol                   = "tcp"
    security_groups            = [aws_security_group.web_sg.id]
    ipv6_cidr_blocks           = []
    prefix_list_ids            = []
    self                       = false
    cidr_blocks                = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.project_name}-app-sg" })
}


