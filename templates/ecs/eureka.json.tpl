[
  {
    "name": "eureka",
    "image": "${eureka_image}",
    "cpu": ${eureka_cpu},
    "memory": ${eureka_memory},
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/akounts/eureka",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${eureka_port},
        "hostPort": 0
      }
    ]
  }
]
