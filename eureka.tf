resource "aws_alb_target_group" "eureka-target" {
  name = "eureka-target"
  vpc_id = aws_vpc.akounts-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.eureka.health_check_path
    unhealthy_threshold = "2"
  }

  port = 80
  protocol = "HTTP"

  tags  = {
    Name: "eureka-target"
  }
}

resource "aws_alb_listener_rule" "eureka-subdomain-rule" {
  listener_arn = aws_alb_listener.http-listener.arn

  action {
    target_group_arn = aws_alb_target_group.eureka-target.arn
    type = "forward"
  }

  condition {
    host_header {
      values = [var.eureka.service_url]
    }
  }
}

resource "aws_route53_record" "eureka-domain-record" {
  name = var.eureka.service_url
  type = "A"
  zone_id = var.dns_zone_id

  alias {
    evaluate_target_health = true
    name = aws_alb.akounts-alb.dns_name
    zone_id = aws_alb.akounts-alb.zone_id
  }
}

resource "aws_cloudwatch_log_group" "eureka_log_group" {
  name              = "/ecs/akounts/eureka"
  retention_in_days = 30

  tags = {
    Name = "eureka-log-group"
  }
}

data "template_file" "eureka" {
  template = file("./templates/ecs/eureka.json.tpl")

  vars = {
    eureka_image      = var.eureka.image
    eureka_port       = var.eureka.port
    eureka_cpu    = var.eureka.cpu
    eureka_memory = var.eureka.memory

    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "eureka_task" {
  family                   = "eureka-task"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = data.template_file.eureka.rendered
}

resource "aws_ecs_service" "eureka_service" {
  name            = "eureka-service"
  cluster         = aws_ecs_cluster.akounts_cluster.id
  task_definition = aws_ecs_task_definition.eureka_task.arn
  desired_count   = var.eureka.desired_count

  load_balancer {
    target_group_arn = aws_alb_target_group.eureka-target.id
    container_name   = "eureka"
    container_port   = var.eureka.port
  }

  depends_on = [aws_alb_listener.http-listener]
}
