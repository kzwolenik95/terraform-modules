variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}
variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}
variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}
variable "use_nat_gateway" {
  description = "Use NAT Gateway or NAT Instance"
  type        = bool
  default     = true
}
