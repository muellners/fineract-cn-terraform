data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "ecs_service_role" {
  name = "ecsInstanceRole"
}

resource "aws_iam_instance_profile" "akounts_instance_profile" {
  name = "akounts-instance-profile"
  role = data.aws_iam_role.ecs_service_role.id
}
