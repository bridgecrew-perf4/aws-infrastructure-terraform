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

variable "newbits" {
  default     = "8"
  description = "Number of additional bits with which to extend the prefix"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "type" {
  type        = string
  default     = "public"
  description = "Type of subnets to create (`private` or `public`)"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
}

variable "i_type_octopus" {
  default = "t2.micro"
}

variable "i_type_transcoder" {
  default = "t3.micro"
}

# variable "i_type" {
#   #type    = map(any)
#   default = {
#     i_type_all        = "t2.micro"
#     i_type_transcoder = "t3.micro"
#   }
# }

#################
# RDS variables #
#################
variable "db_type" {
  type    = string
  default = "db.t2.micro"
}

variable "username_db" {
  type    = string
  default = "octopusinfluencer"
}

variable "password_db" {
  type    = string
  default = "test123456!"
}

variable "analytics" {
  default     = "true"
  description = "If set to true, install analytics on EC2"
}

variable "chat" {
  default     = "true"
  description = "If set to true, install chat on EC2"
}

variable "comments" {
  default     = "true"
  description = "If set to true, install comments on EC2"
}

variable "ecommerce" {
  default     = "true"
  description = "If set to true, install ecommerce on EC2"
}

variable "ums" {
  default     = "true"
  description = "If set to true, create ums EC2 instance"
}

# variable "signaling" {
#   default = "true"
#   description = "If set to true, install chat on EC2"
# }

# variable "webpay" {
#   default = "true"
#   description = "If set to true, install webpay on EC2"
# }

# S3 Buckets #
variable "s3bucket_name" {
  type        = list(string)
  default     = ["octopus-server", "private-octopus-server-s3", "chat-server-user-attachments", "chat-server-canned-attachments", "ecommerce-s3", "private-ecommerce-s3"]
  description = "List of S3 Buckets to create"
}