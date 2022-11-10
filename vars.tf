variable "REGION" {
  default = "us-east-2"

}
variable "ZONES" {
  type = map(any)
  default = {
    us-east-2 = "us-east-2a"
    us-east-1 = "us-east-1a"

  }

}
variable "AMIS" {
  type = map(any)
  default = {
    us-east-2 = "ami-089a545a9ed9893b6"
    us-east-1 = "ami-09d3b3274b6c5d4aa"

  }

}
variable "KEYS" {
  type = map(any)
  default = {
    us-east-1 = "keyname"
    us-east-2 = "keyname"
  }

}
variable "SG" {
  type = map(any)
  default = {
    us-east-2 = ["sg-0030af426c8d42b6a"]
    us-east-1 = ["sg-0ee744c0c761a429a"]

  }

}
variable "USER" {
  default = "ec2-user"

}