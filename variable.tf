/*variable "access_key" {
  type = "string"
  description = "access_key"
}

variable "secret_key" {
  type = "string"
  description = "secret key"
}*/

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
 default = "10.1.0.0/16"
  } 
variable "websubnet1_cidr" {
  type = "string"
  description = "describe your variable"
  default = "10.1.1.0/24"
}

variable "websubnet2_cidr" {
  type = "string"
  description = "describe your variable"
  default = "10.1.2.0/24"
}

variable "appsubnet1_cidr_block" {
  type = "string"
  description = "describe your variable"
  default = "10.1.3.0/24"
}

variable "appsubnet2_cidr_block" {
  type = "string"
  description = "describe your variable"
  default = "10.1.4.0/24"
}