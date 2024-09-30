variable "eks_public_subnet_cidr_blocks" {
  type = list(string)
  default = ["10.20.1.0/24","10.20.2.0/24"]
}

variable "eks_private_subnet_cidr_blocks" {
  type = list(string)
  default = ["10.20.3.0/24","10.20.4.0/24"]
}

variable "eks_vpc_cidr" {
  type = string
  default = "10.20.0.0/16"
}
