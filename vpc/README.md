vpc terraform module
====================

A terraform module to provide a virtual private cloud (VPC) in AWS.

The VPC is provisioned across 3 availability zones (AZs) with 3 subnets per AZ.

The subnet design is a modified version from [Practical VPC Design](https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc).

This module performs creates the following
- VPC
- Internet gateway
- Route table with internet gateway as the default route
- For each availability zone:
  - Subnets
    - Public
    - Protected
    - Private
  - NAT interface
  - Route table with NAT interface as the default route
- NAT security group applied to NAT interfaces
  - Allows all inbound traffic from VPC (`cidr`)
  - Allows all outbound traffic to `0.0.0.0/0`


VPC Subnet Design
-----------------

- 10.0.0.0/16 - VPC on 10.0.0.0/16
  - 10.0.0.0/18 — AZ Alpha
    - 10.0.0.0/19 — Private
      - 10.0.32.0/19
        - 10.0.32.0/20 — Protected
        - 10.0.48.0/20
          - 10.0.48.0/21 — Public
          - 10.0.56.0/21 — Spare (unused)
  - 10.0.64.0/18 — AZ Bravo
    - 10.0.64.0/19 — Private
      - 10.0.96.0/19
        - 10.0.96.0/20 — Protected
        - 10.0.112.0/20
          - 10.0.112.0/21 — Public
          - 10.0.120.0/21 — Spare (unused)
  - 10.0.128.0/18 — AZ Charlie
    - 10.0.128.0/19 — Private
      - 10.0.160.0/19
        - 10.0.160.0/20 — Protected
        - 10.0.176.0/20
          - 10.0.176.0/21 — Public
          - 10.0.184.0/21 — Spare (unused)
  - 10.0.192.0/18 - Spare (unused)

Module Input Variables
----------------------

- `name` - Name of VPC
- `cidr` - CIDR to allocate for VPC (must be a /16)
  - Default: ```"10.0.0.0/16"```
- `region` - AWS region to utilize
- `availability_zones` - availability zones within `region` to utilize (must be a comma separated list of 3 zone suffixes)
  - Default: ```"a,b,c"```
- `environment` - Environment AWS tag
  - Default: ```""```


Usage
-----

```js
module "vpc" {
  source = "github.com/mrjefftang/terraform-modules//vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  region =  "us-west-2"
  availability_zones = "a,b,c"
  environment = "test"
}
```

Outputs
=======

 - `vpc_id` - VPC id
 - `private_subnets` - comma separated list of private subnet ids
 - `protected_subnets` - comma separated list of protected subnet ids
 - `public_subnets` - comma separated list of public subnet ids
 - `private_cidr` - comma separated list of private subnet CIDR
 - `protected_cidr` - comma separated list of protected subnet CIDR
 - `public_cidr` - comma separated list of public subnet CIDR
 - `nat_interfaces` - comma separated list network interfaces for NAT interfaces
 - `nat_security_group_id` - NAT security group id
 - `availability_zones` - comma separated list of availability zones


Authors
=======

Created by [Jeff Tang](https://github.com/mrjefftang)

License
=======

MIT Licensed. See LICENSE for full details.
