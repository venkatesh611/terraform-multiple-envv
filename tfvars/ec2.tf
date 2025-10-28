resource "aws_instance" "terraform" {
    for_each = toset(var.instances)
    ami           = local.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags = merge(
        var.ec2_tags,
        { Name = each.value}
       
    )
    provisioner "local-exec" {
      command = "echo Instance ${self.id} with IP ${self.public_ip} has been created"
      on_failure = continue
    }
    provisioner "local-exec" {
      command = "echo instance_id=${self.id} was deleted"
      when    = destroy
    }
    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = self.public_ip
    }
     # 🧠 Conditional remote-exec based on instance name
provisioner "remote-exec" {
  inline = compact([
    "sudo dnf update -y",
    each.value == "web-1" ? "sudo dnf install -y nginx && sudo systemctl enable --now nginx" : "",
    each.value == "web-2" ? "sudo dnf install -y mysql-server && sudo systemctl enable --now mysqld" : "",
    each.value == "web-3" ? "sudo dnf install -y prometheus" : ""
  ])
}


  
}
resource "aws_security_group" "allow_all" {

    name        = var.sg-name
    description = "Security group to allow all inbound and outbound traffic"
    dynamic "ingress" {
        for_each = toset(var.ingress-ports) 
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp" 
            #var.ingress-protocol # -1 means all protocols
            cidr_blocks = var.ingress-cidr-blocks # internet
        }
    }
    egress {
        from_port   = var.egress-from-port
        to_port     = var.egress-to-port
        protocol    = var.egress-protocol
        cidr_blocks = var.egress-cidr-blocks
    }
  
    tags = var.security_group_tags
  
}