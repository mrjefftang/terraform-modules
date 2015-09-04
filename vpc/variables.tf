# VPC Settings
variable "name" {
    description = "Name of VPC"
}

variable "cidr" {
    description = "CIDR to allocate for VPC (must be a /16)"
    default = "10.0.0.0/16"
}

variable "region" {
    description = "AWS region to utilize"
}

variable "availability_zones" {
    description = "AWS availability zones within `aws_region` to utilize"
    default = "a,b,c"
}

variable "environment" {
    description = "Environment AWS tag"
    default = ""
}

# VPC subnet design (shouldn't have to be changed)
variable "zone_cidrs" {
    description = "AWS VPC subnet design for 3 AZs and 3 layers with reserved space"
    default = {
        "0.priv" = "0.0/19"
        "0.prot" = "32.0/20"
        "0.pub" = "48.0/21"
        "1.priv" = "64.0/19"
        "1.prot" = "96.0/20"
        "1.pub" = "112.0/21"
        "2.priv" = "128.0/19"
        "2.prot" = "160.0/20"
        "2.pub" = "176.0/21"
    }
}
