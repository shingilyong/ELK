variable "region" {
    default = "ap-northeast-2"
}


variable "cidr_block" {
    type = map
    default = {
        cidr_all = "0.0.0.0/0"
        cidr_vpc = "192.168.0.0/16"
        cidr_subnet = "192.168.10.0/24"
    }
}

variable "ami" {
    type = string
    default = "ami-081511b9e3af53902"
}


variable "az" {
    type = map
    default = {
        a = "ap-northeast-2a"
        c = "ap-northeast-2c"
    }
}

