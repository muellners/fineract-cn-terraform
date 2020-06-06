data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
