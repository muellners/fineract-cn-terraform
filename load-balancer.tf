resource "aws_alb" "akounts-alb" {
  name = "akounts-alb"
  subnets = [aws_subnet.akounts-public-1.id, aws_subnet.akounts-public-2.id]
  security_groups = [aws_security_group.alb.id]

  tags = {
    Name = "akounts-alb"
  }
}

resource "aws_alb_listener" "http-listener" {
  load_balancer_arn = aws_alb.akounts-alb.arn
  protocol = "HTTP"
  port = 80

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html>Page Not Found</html>"
      status_code = "200"
    }
  }
}
