# Public Routes --------------------------------------------

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index) # Dynamically derived subnet
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.vpc_name}-public-${count.index}" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = { Name = "${var.vpc_name}-public-rt" }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


# Private Routes -------------------------------------------------

resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.availability_zones)) # Offset for private subnets
  availability_zone = element(var.availability_zones, count.index)
  tags              = { Name = "${var.vpc_name}-private-${count.index}" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = { Name = "${var.vpc_name}-private-rt" }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

