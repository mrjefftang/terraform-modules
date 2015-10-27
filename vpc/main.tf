resource "aws_vpc" "main" {
    cidr_block = "${var.cidr}"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags {
        Name = "${var.name}"
        Environment = "${var.environment}"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "igw-main"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }

    tags {
        Name = "rt-main-public"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.main.id}"
    count = 3

    tags {
        Name = "rt-${element(split(",", var.availability_zones), count.index)}-nat"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
    count = 3
}

resource "aws_route_table_association" "nat-prot" {
    subnet_id = "${element(aws_subnet.protected.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
    count = 3
}

resource "aws_route_table_association" "nat-priv" {
    subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
    count = 3
}

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.main.id}"
    availability_zone = "${concat(var.region, element(split(",", var.availability_zones), count.index))}"
    cidr_block = "${format("%s.%s.%s", element(split(".", var.cidr), 0), element(split(".", var.cidr), 1), lookup(var.zone_cidrs, concat(count.index, ".priv")))}"
    map_public_ip_on_launch = "false"
    count = 3
    tags {
        Name = "vlan-${element(split(",", var.availability_zones), count.index)}-priv"
        Environment = "${var.environment}"
    }
}

resource "aws_subnet" "protected" {
    vpc_id = "${aws_vpc.main.id}"
    availability_zone = "${concat(var.region, element(split(",", var.availability_zones), count.index))}"
    cidr_block = "${format("%s.%s.%s", element(split(".", var.cidr), 0), element(split(".", var.cidr), 1), lookup(var.zone_cidrs, concat(count.index, ".prot")))}"
    map_public_ip_on_launch = "false"
    count = 3
    tags {
        Name = "vlan-${element(split(",", var.availability_zones), count.index)}-prot"
        Environment = "${var.environment}"
    }
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.main.id}"
    availability_zone = "${concat(var.region, element(split(",", var.availability_zones), count.index))}"
    cidr_block = "${format("%s.%s.%s", element(split(".", var.cidr), 0), element(split(".", var.cidr), 1), lookup(var.zone_cidrs, concat(count.index, ".pub")))}"
    map_public_ip_on_launch = "true"
    count = 3
    tags {
        Name = "vlan-${element(split(",", var.availability_zones), count.index)}-pub"
        Environment = "${var.environment}"
    }
}
