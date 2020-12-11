variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "var_name" {
  type    = string
  default = "blizzard"
}

variable "var_dev_environment" {
  type    = string
  default = "stage"
}

variable "vpc_cidr" {
  default = "200.1.0.0/16"
}

variable "public_cidr_block" {
#   type = map(object({
#     cidr_block = string
#   }))
    type = any
    default = ["200.1.1.0/24","200.1.2.0/24"]
}