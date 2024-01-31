variable "vpc-cidr" {
  type        = string
  default = "10.0.0.0/16"
  description = "cidr block for vpc"
}
variable "vpc-name" {
  type        = string
  default = "ninja-vpc-01"
  description = "vpc name"
}

variable "cidr_pub" {
   type = list(string)
   default = ["10.0.2.0/28","10.0.4.0/28"]
   description = "cidr for public subnets"

}


variable "cidr_pir" {
   type = list(string)
   default = ["10.0.6.0/28","10.0.8.0/28"]
   description = "cidr range for private subnets"
}

variable "pub_az" {
   type = list(string)
   default = ["us-east-1a","us-east-1b"]
   description = "availability zone for public subnet"
}

variable "pir_az" {
   type = list(string)
   default = ["us-east-1a","us-east-1b"]
   description = "availability zone for private subnet"
}
     






variable "IG" {
  type        = string
  default = "ninja-igw-01"
  description = "internet gatway for vpc"
}

variable "rt_ip" {
  type        = string
  default = "0.0.0.0/0"
  description = "ip for public route - internet gateway"
}

variable "pvt_rt_ip" {
  type        = string
  default = "0.0.0.0/0"
  description = "ip for private route - internet gateway"
}

variable "rt_name" {
  type        = string
  default = "ninja-route-pub-01"
  description = "public route table"
}

variable "pir-rt-name" {
  type        = string
  default = "ninja-route-priv-01"
  description = "private route table"
}

variable "nat_type" {
  type        = string
  default = "public"
  description = "connectivity type for nat gateway"
}

variable "nat-name" {
  type        = string
  default = "ninja-nat-01"
  description = "name for nat gateway"
}
variable "amii" {
  type        = string
  default = "ami-06aa3f7caf3a30282"
  description = "image for ec2 instance"
}

variable "type" {
  type        = string
  default = "t2.micro"
  description = "instance type"
}

variable "sg" {
  type        = string
  default = "ninja-sg"
  description = "security group name"
}

variable "ec2_type" {
  type        = string
  default = "t2.micro"
  description = "instance type"
}

variable "ami_type" {
  type        = string
  default = "ami-06aa3f7caf3a30282"
  description = "image of ubuntu 20 version "
}
variable "key" {
  type        = string
  default = "server_key2"
  description = "ssh key for bestion host "
}

variable "bestion" {
  type        = string
  default = "bestion_host"
  description = "name for bestion host"
}

variable "pub_instance" {
  type        = string
  default = "public_instance"
  description = "name for private server"
}

variable "sg_port" {
  type        = number
  default = 22
  description = "ssh port 22 for connection "
}

variable "sg_protocol" {
  type        = string
  default = "TCP"
  description = "TCP protocol for connection "
}


variable "sg_cidr" {
  type        = string
  default = "0.0.0.0/0"
  description = "source for connection"
}

