resource "aws_instance" "terraform" {
    for_each = toset(var.instances)
    ami           = local.ami_id
    instance_type = lookup(var.instance_type , terraform.workspace, "t2.small")
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags =merge(
        local.common_ec2_tags,
        { Name = "{${each.value} ${terraform.workspace}}"}
    )
}
resource "aws_security_group" "allow_all" {
    name        = "{${var.sg-name}-${terraform.workspace}}"
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
        cidr_blocks = var.egress_cidr_blocks
    }
  
    tags = var.security_group_tags
  
}