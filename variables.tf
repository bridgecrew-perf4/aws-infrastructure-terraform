####################
#       AWS        #
####################
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

# Environment #
variable "var_name" {
  type    = string
  default = "blizzard"
}

variable "var_dev_environment" {
  type    = string
  default = "stage"
}

####################
#     Networks     #
####################
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

####################
#   EC2 Instance   #
####################
variable "i_tags" {
  type    = list(string)
  default = ["all", "transcoder"]
}

variable "i_type_octopus" {
  default = "t2.micro"
}

variable "i_type_transcoder" {
  default = "t3.micro"
}

####################
# Ansible Playbook #
####################
variable "ansible_playbook" {
  type    = list(string)
  default = ["./octopus_setup_all.yml", "./octopus_setup_transcoder.yml"]
}

variable "analytics" {
  default     = "true"
  description = "If set to true, install octopus-analytics service"
}

variable "chat" {
  default     = "true"
  description = "If set to true, install octopus-chat service"
}

variable "comments" {
  default     = "true"
  description = "If set to true, install octopus-comments service"
}

variable "ecommerce" {
  default     = "true"
  description = "If set to true, install octopus-ecommerce service"
}

variable "ums" {
  default     = "true"
  description = "If set to true, install UMS service"
}

variable "signaling" {
  default     = "true"
  description = "If set to true, install signaling service"
}

variable "webpay" {
  default     = "true"
  description = "If set to true, install webpay service"
}

####################
#       RDS        #
####################
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

####################
#    S3 Buckets    #
####################
variable "s3bucket_name" {
  type        = list(string)
  default     = ["octopus-server", "private-octopus-server-s3", "chat-server-user-attachments", "chat-server-canned-attachments", "ecommerce-s3", "private-ecommerce-s3"]
  description = "List of S3 Buckets to create"
}