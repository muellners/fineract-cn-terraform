variable "eureka" {
  type = object({
    service_name: string,
    log_group: string,
    image: string,
    cpu: number,
    memory: number,
    port: number,
    health_check_path: string,
    desired_count: number,
    hostname: string,
    default_zone: string,
    service_url: string
  })
}

variable "provisioner" {
  type = object({
    service_name: string,
    log_group: string,
    image: string,
    cpu: number,
    memory: number,
    port: number,
    health_check_path: string,
    desired_count: number,
    service_url: string
  })
}

variable "identity" {
  type = object({
    service_name: string,
    log_group: string,
    image: string,
    cpu: number,
    memory: number,
    port: number,
    health_check_path: string,
    desired_count: number,
    service_url: string
  })
}

variable "customer" {
  type = object({
    service_name: string,
    log_group: string,
    image: string,
    cpu: number,
    memory: number,
    port: number,
    health_check_path: string,
    desired_count: number,
    service_url: string
  })
}

variable "accounting" {
  type = object({
    service_name: string,
    log_group: string,
    image: string,
    cpu: number,
    memory: number,
    port: number,
    health_check_path: string,
    desired_count: number,
    service_url: string
  })
}

variable "deposit" {
  type = object({
    service_name: string,
    log_group: string,
    image: string,
    cpu: number,
    memory: number,
    port: number,
    health_check_path: string,
    desired_count: number,
    service_url: string
  })
}
