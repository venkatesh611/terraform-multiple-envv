locals {
  ami_id=data.aws_ami.jiondevops.id
  instance_type=var.instance_type
}