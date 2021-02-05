####################
#       AWS        #
####################
variable "region" {
  type    = string
}

variable "aws_access_key" {
  type    = string
}

variable "aws_secret_key" {
  type    = string
}
###################
#   Environment   #
###################
variable "var_name" {
  type    = string
}

variable "var_dev_environment" {
  type    = string
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
  default     = ["eu-west-1a", "eu-west-1b"]
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
}

####################
#   EC2 Instance   #
####################
variable "i_tags" {
  type    = list(string)
  default = ["all", "trn"]
}

variable "i_type_devops_service" {
}

variable "i_type_trn" {
}

####################
# Ansible Playbook #
####################
variable "ansible_playbook" {
  type    = list(string)
  default = ["./ansible/devops_service_setup_all.yml", "./ansible/devops_service_setup_trn.yml"]
}

variable "var_lyrics" {
  description = "If set to true, install devops_service-lyrics service"
}

variable "var_chat" {
  description = "If set to true, install devops_service-chat service"
}

variable "var_ments" {
  description = "If set to true, install devops_service-ments service"
}

variable "var_commerce" {
  description = "If set to true, install devops_service-commerce service"
}

variable "var_user" {
  description = "If set to true, install user service"
}

variable "var_sign" {
  description = "If set to true, install sign service"
}

variable "var_payweb" {
  description = "If set to true, install payweb service"
}

variable "var_subs" {
  description = "If set to true, install subs service"
}

####################
#       RDS        #
####################
variable "db_type" {
  type    = string
}

variable "var_username_db" {
  type    = string
}

variable "var_password_db" {
  type    = string
}

####################
#    S3 Buckets    #
####################
variable "s3bucket_name" {
  type        = list(string)
  default     = ["devops_service-server", "private-devops_service-server-s3", "chat-server-user-attachments", "chat-server-canned-attachments", "commerce-s3", "private-commerce-s3"]
  description = "List of S3 Buckets to create"
}
