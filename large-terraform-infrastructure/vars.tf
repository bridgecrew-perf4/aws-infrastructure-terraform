####################
#       AWS        #
####################
variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}
###################
#   Environment   #
###################
variable "var_name" {
  type    = string
  default = "devops"
}

variable "var_dev_environment" {
  type    = string
  default = "test"
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
  default = ["octopus-1", "octopus-2", "all", "transcoder", "webserver"]
}

variable "i_type_octopus_1" {
  type    = string
  default = "t3.micro"
}

variable "i_type_octopus_2" {
  type    = string
  default = "t3.micro"
}

variable "i_type_all" {
  type    = string
  default = "t3.micro"
}

variable "i_type_transcoder" {
  type    = string
  default = "t3.medium"
}

variable "i_type_webserver" {
  type    = string
  default = "t3.micro"
}
####################
# Ansible Playbook #
####################
variable "ansible_playbook" {
  type    = list(string)
  default = ["./ansible/octopus_server_setup.yml", "./ansible/octopus_server_setup.yml", "./ansible/octopus_setup_all.yml", "./ansible/octopus_setup_transcoder.yml", "./ansible/webserver_setup.yml"]
}

variable "var_analytics" {
  description = "If set to true, install octopus-analytics service"
  default = true
}

variable "var_chat" {
  description = "If set to true, install octopus-chat service"
  default = true
}

variable "var_comments" {
  description = "If set to true, install octopus-comments service"
  default = true
}

variable "var_ecommerce" {
  description = "If set to true, install octopus-ecommerce service"
  default = true
}

variable "var_ums" {
  description = "If set to true, install UMS service"
  default = true
}

variable "var_signaling" {
  description = "If set to true, install signaling service"
  default = true
}

variable "var_webpay" {
  description = "If set to true, install webpay service"
  default = true
}

variable "var_subscription" {
  description = "If set to true, install subscription service"
  default = true
}

variable "var_quizz" {
  description = "If set to true, install quizz service"
  default = true
}

variable "var_schedule" {
  description = "If set to true, install schedule service"
  default = true
}

####################
#       RDS        #
####################
variable "db_type" {
  type    = string
  default = "db.t3.micro"
}

variable "var_username_db" {
  type    = string
  default = "test"
}

variable "var_password_db" {
  type    = string
  default = "test123!"
}

variable "d_tags" {
  type    = list(string)
  default = ["octopus", "all"]
}

####################
#    S3 Buckets    #
####################
variable "s3bucket_name" {
  type        = list(string)
  default     = ["octopus-server", "private-octopus-server-s3", "chat-server-user-attachments", "chat-server-canned-attachments", "ecommerce-s3", "private-ecommerce-s3"]
  description = "List of S3 Buckets to create"
}
