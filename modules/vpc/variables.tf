variable "environment" {
  description = "value"
}

variable "aws_vpc" {
  description = "value"
  default = "10.0.0.0/16"
}

variable "Pub-subnet_cidr-1" {
  description = "value"
  default = "10.0.1.0/24"
}

variable "Pub-subnet_cidr-2" {
  description = "value"
  default = "10.0.2.0/24"
}

variable "pvt-subnet-cidr-1" {
  description = "value"
  default = "10.0.3.0/24"
}

variable "pvt-subnet-cidr-2" {
  description = "value"
  default = "10.0.4.0/24"
}

variable "avail-zone-pub1" {
  description = "value"
  default = "ap-south-2a"
}

variable "avail-zone-pub2" {
  description = "value"
  default = "ap-south-2b"
}

variable "avail-zone-pvt1" {
  description = "value"
  default = "ap-south-2a"
}

variable "avail-zone-pvt2" {
  description = "value"
  default = "ap-south-2b"
}

variable "cidr_pub_route" {
  description = "value"
  default = "0.0.0.0/0"
}

variable "cidr-pvt-route" {
  description = "value"
  default = "0.0.0.0/0"
}