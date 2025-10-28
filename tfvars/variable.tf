variable "ami_id" {
  default = "ami-0c02fb55956c7d316"
}
variable "environment" {
  type = string
}

variable "instance_type" {
  default = "t3.micro"
}
variable "ec2_tags" {
    default = {
    
    Project     = "roboshop"
    Terraform   = "true"
    }

}
variable "instances" {
    description = "A list of EC2 instance names"
    type        = list(string)
    default     = ["web-1", "web-2", "web-3"]
  
}
#security group related variables
variable "sg-name" {
    description = "The name of the security group"
    type        = string
    default     = "allow-all-roboshop"
}
variable "ingress-from-port" {
     default = 0
}
variable "ingress-to-port" {
     default = 0
}
variable "ingress-protocol" {
     default = "-1"
}
variable "ingress-cidr-blocks" {
     default = ["0.0.0.0/0"]
}
variable "egress-from-port" {
     default = 0
}
variable "egress-to-port" {
     default = 0
}
variable "egress-protocol" {
     default = "-1"
}
variable "egress-cidr-blocks" {
     default = ["0.0.0.0/0"]
}
variable "ingress-ports" {
    description = "A list of ingress ports"
    type        = list(number)
    default     = [22, 80, 8080, 3306]
  
}
variable "security_group_tags" {
    default = {
    
    Project     = "roboshop"
    Terraform   = "true"
    }
  
}