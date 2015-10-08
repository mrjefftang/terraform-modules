output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "private_subnets" {
    value = "${join(", ", aws_subnet.private.*.id)}"
}

output "protected_subnets" {
    value = "${join(", ", aws_subnet.protected.*.id)}"
}

output "public_subnets" {
    value = "${join(", ", aws_subnet.public.*.id)}"
}

output "private_cidr" {
    value = "${join(", ", aws_subnet.private.*.cidr_block)}"
}

output "protected_cidr" {
    value = "${join(", ", aws_subnet.protected.*.cidr_block)}"
}

output "public_cidr" {
    value = "${join(", ", aws_subnet.public.*.cidr_block)}"
}

output "nat_interfaces" {
    value = "${join(", ", aws_network_interface.nat.*.id)}"
}

output "nat_security_group_id" {
    value = "${aws_security_group.nat.id}"
}

output "availability_zones" {
    value = "${join(", ", aws_subnet.private.*.availability_zone)}"
}
