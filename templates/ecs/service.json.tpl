[
  {
    "name": "${service_name}",
    "image": "${service_image}",
    "cpu": ${service_cpu},
    "memory": ${service_memory},
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${service_log_group}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${service_port},
        "hostPort": 0
      }
    ],
    "environment": [
      {"name": "system.publicKey.timestamp", "value": "${public_key_timestamp}"},
      {"name": "system.publicKey.modulus", "value": "${public_key_modulus}"},
      {"name": "system.publicKey.exponent", "value": "${public_key_exponent}"},
      {"name": "system.privateKey.modulus", "value": "${private_key_modulus}"},
      {"name": "system.privateKey.exponent", "value": "${private_key_exponent}"},
      {"name": "eureka.client.fetchRegistry", "value": "true"},
      {"name": "activemq.brokerUrl", "value": "${activemq_broker_url}"},
      {"name": "activemq.username", "value": "${activemq_username}"},
      {"name": "activemq.password",	"value": "${activemq_password}"},
      {"name": "cassandra.cluster.user", "value": "${cassandra_user}"},
      {"name": "cassandra.cluster.pwd", "value": "${cassandra_password}"},
      {"name": "cassandra.clusterName",	"value": "${cassandra_cluster_name}"},
      {"name": "cassandra.contactPoints", "value": "${cassandra_contact_points}"},
      {"name": "cassandra.keyspace", "value": "${cassandra_keyspace}"},
      {"name": "cassandra.cl.delete", "value": "ONE"},
      {"name": "cassandra.cl.read", "value": "ONE"},
      {"name": "cassandra.cl.write", "value": "ONE"},
      {"name": "eureka.client.initialInstanceInfoReplicationIntervalSeconds", "value": "10"},
      {"name": "eureka.client.instanceInfoReplicationIntervalSeconds", "value": "1"},
      {"name": "eureka.client.serviceUrl.defaultZone", "value": "${eureka_default_zone}"},
      {"name": "eureka.client.serviceUrl.registerWithEureka", "value": "true"},
      {"name": "eureka.instance.hostname", "value": "${service_url}"},
      {"name": "eureka.instance.nonSecurePort", "value": "80"},
      {"name": "eureka.instance.leaseRenewalIntervalInSeconds", "value": "10"},
      {"name": "eureka.registration.enabled", "value": "true"},
      {"name": "feign.hystrix.enabled", "value": "false"},
      {"name": "portfolio.bookLateFeesAndInterestAsUser", "value": "service-runner"},
      {"name": "postgresql.host", "value": "${postgres_host}"},
      {"name": "postgresql.user", "value": "${postgres_user}"},
      {"name": "postgresql.password", "value": "${postgres_password}"},
      {"name": "rhythm.beatCheckRate", "value": "60000"},
      {"name": "rhythm.user", "value": "imhotep"},
      {"name": "ribbon.eureka.enabled", "value": "true"},
      {"name": "ribbon.listOfServers", "value": "${eureka_hostname}"},
      {"name": "server.max-http-header-size", "value": "24576"},
      {"name": "spring.cloud.config.enabled", "value": "false"},
      {"name": "spring.cloud.discovery.enabled", "value": "true"},
      {"name": "system.initialclientid", "value" :"service-runner"}
    ]
  }
]
