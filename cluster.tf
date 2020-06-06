resource "aws_ecs_cluster" "akounts_cluster" {
  name = "akounts-cluster"
}

resource "aws_launch_configuration" "akounts_launchconfig" {
  image_id = data.aws_ami.amazon_linux_ami.id
  instance_type = var.cluster_instance_type
  spot_price = ""
  name_prefix = "akounts-launchconfig"
  iam_instance_profile = aws_iam_instance_profile.akounts_instance_profile.id
  security_groups = [aws_security_group.ecs_instance.id]
  user_data = <<SCRIPT
  #!/bin/bash
  echo ECS_CLUSTER=${aws_ecs_cluster.akounts_cluster.name} >> /etc/ecs/ecs.config
  SCRIPT

  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "akounts_autoscaling" {
  vpc_zone_identifier = [aws_subnet.akounts-public-1.id]
  launch_configuration = aws_launch_configuration.akounts_launchconfig.id
  max_size = 4
  min_size = 4

  tag {
    key = "Name"
    value = "akounts-cluster-instance"
    propagate_at_launch = true
  }
}
