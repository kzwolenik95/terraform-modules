# VPC Networking Module

This Terraform module creates a Virtual Private Cloud (VPC) with optional public subnets, private subnets, and a choice between a NAT Gateway or NAT Instance. It is designed for self-service infrastructure provisioning, allowing users to easily configure and manage their VPC.

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables:

| Name            | Description                                           | Type         | Default | Required |
| --------------- | ----------------------------------------------------- | ------------ | ------- | -------- |
| vpc_cidr_block  | The CIDR block for the VPC                            | string       | n/a     | yes      |
| vpc_name        | Name of the VPC                                       | string       | n/a     | yes      |
| tags            | Tags to apply to resources                            | map(string)  | {}      | no       |
| public_subnets  | List of public subnet CIDR blocks                     | list(string) | n/a     | no       |
| private_subnets | List of private subnet CIDR blocks                    | list(string) | n/a     | yes      |
| azs             | List of availability zones                            | list(string) | n/a     | yes      |
| use_nat_gateway | Use NAT Gateway or NAT Instance, true for NAT Gateway | bool         | true    | no       |

Example usage of the module is presented in the [**examples**](examples) directory

## License

This module is licensed under the [MIT License](LICENSE.txt).

## Authors

Created and maintained by Krzysztof Zwolenik.
