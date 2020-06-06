resource "aws_alb_target_group" "deposit_target" {
  name = "deposit-target"
  vpc_id = aws_vpc.akounts-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "404"
    timeout             = "3"
    path                = var.deposit.health_check_path
    unhealthy_threshold = "2"
  }

  port = 80
  protocol = "HTTP"

  tags  = {
    Name: "deposit_target"
  }
}

resource "aws_alb_listener_rule" "deposit_subdomain_rule" {
  listener_arn = aws_alb_listener.http-listener.arn

  action {
    target_group_arn = aws_alb_target_group.deposit_target.arn
    type = "forward"
  }

  condition {
    host_header {
      values = [var.deposit.service_url]
    }
  }
}

resource "aws_route53_record" "deposit_domain_record" {
  name = var.deposit.service_url
  type = "A"
  zone_id = var.dns_zone_id

  alias {
    evaluate_target_health = true
    name = aws_alb.akounts-alb.dns_name
    zone_id = aws_alb.akounts-alb.zone_id
  }
}

resource "aws_cloudwatch_log_group" "deposit_log_group" {
  name              = "/ecs/akounts/deposit"
  retention_in_days = 30

  tags = {
    Name = "deposit-log-group"
  }
}

data "template_file" "deposit_tasks_data" {
  template = file("./templates/ecs/service.json.tpl")

  vars = {
    service_name = var.deposit.service_name
    service_url = var.deposit.service_url
    service_image = var.deposit.image
    service_port = var.deposit.port
    service_cpu = var.deposit.cpu
    service_memory = var.deposit.memory
    service_log_group = var.deposit.log_group

    public_key_timestamp = var.service_key_details.public_key_timestamp
    public_key_modulus = var.service_key_details.public_key_modulus
    public_key_exponent = var.service_key_details.public_key_exponent
    private_key_modulus = var.service_key_details.private_key_modulus
    private_key_exponent = var.service_key_details.private_key_exponent

    postgres_host = var.postgres_details.host
    postgres_user = var.postgres_details.username
    postgres_password = var.postgres_details.password

    activemq_broker_url = var.activemq_details.broker_url
    activemq_username = var.activemq_details.username
    activemq_password = var.activemq_details.password

    cassandra_user = var.cassandra_details.username
    cassandra_password = var.cassandra_details.password
    cassandra_cluster_name = var.cassandra_details.cluster_name
    cassandra_contact_points = var.cassandra_details.contact_points
    cassandra_keyspace = var.cassandra_details.keyspace

    eureka_default_zone = var.eureka.default_zone
    eureka_hostname = var.eureka.hostname

    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "deposit_task" {
  family                   = "deposit_task"
  cpu                      = var.deposit.cpu
  memory                   = var.deposit.memory
  container_definitions    = data.template_file.deposit_tasks_data.rendered
}

resource "aws_ecs_service" "deposit_service" {
  name            = "deposit_service"
  cluster         = aws_ecs_cluster.akounts_cluster.id
  task_definition = aws_ecs_task_definition.deposit_task.arn
  desired_count   = var.eureka.desired_count

  load_balancer {
    target_group_arn = aws_alb_target_group.deposit_target.id
    container_name   = "deposit"
    container_port   = var.deposit.port
  }

  depends_on = [aws_alb_listener.http-listener,
    aws_ecs_service.provisioner_service,
    aws_ecs_service.identity_service]
}
