resource "aws_alb_target_group" "provisioner-target" {
  name = "provisioner-target"
  vpc_id = aws_vpc.akounts-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.provisioner.health_check_path
    unhealthy_threshold = "2"
  }

  port = 80
  protocol = "HTTP"

  tags  = {
    Name: "provisioner-target"
  }
}

resource "aws_alb_listener_rule" "provisioner-subdomain-rule" {
  listener_arn = aws_alb_listener.http-listener.arn

  action {
    target_group_arn = aws_alb_target_group.provisioner-target.arn
    type = "forward"
  }

  condition {
    host_header {
      values = [var.provisioner.service_url]
    }
  }
}

resource "aws_route53_record" "provisioner-domain-record" {
  name = var.provisioner.service_url
  type = "A"
  zone_id = var.dns_zone_id

  alias {
    evaluate_target_health = true
    name = aws_alb.akounts-alb.dns_name
    zone_id = aws_alb.akounts-alb.zone_id
  }
}

resource "aws_cloudwatch_log_group" "provisioner_log_group" {
  name              = "/ecs/akounts/provisioner"
  retention_in_days = 30

  tags = {
    Name = "provisioner-log-group"
  }
}

data "template_file" "provisioner_tasks_data" {
  template = file("./templates/ecs/service.json.tpl")

  vars = {
    service_name = var.provisioner.service_name
    service_url = var.provisioner.service_url
    service_image = var.provisioner.image
    service_port = var.provisioner.port
    service_cpu = var.provisioner.cpu
    service_memory = var.provisioner.memory
    service_log_group = var.provisioner.log_group

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

resource "aws_ecs_task_definition" "provisioner_task" {
  family                   = "provisioner_task"
  cpu                      = var.provisioner.cpu
  memory                   = var.provisioner.memory
  container_definitions    = data.template_file.provisioner_tasks_data.rendered
}

resource "aws_ecs_service" "provisioner_service" {
  name            = "provisioner_service"
  cluster         = aws_ecs_cluster.akounts_cluster.id
  task_definition = aws_ecs_task_definition.provisioner_task.arn
  desired_count   = var.eureka.desired_count

  load_balancer {
    target_group_arn = aws_alb_target_group.provisioner-target.id
    container_name   = "provisioner"
    container_port   = var.provisioner.port
  }

  depends_on = [aws_alb_listener.http-listener,
    aws_ecs_service.eureka_service]
}
