resource "aws_security_group" "alb" {
  name        = "alb-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.akounts-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_instance" {
  name        = "ecs-instance"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.akounts-vpc.id

  ingress {
    from_port = 32768
    to_port = 61000
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
