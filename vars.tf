variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  description = "The AWS region things are created in"
  type = string
  default = "ap-south-1"
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "cluster_instance_type" {
  type = string
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "1"
}

variable "dns_zone_id" {
  description = "The Zone ID of Domain name in Route53."
  type = string
}

variable "service_key_details" {
  type = object({
    public_key_timestamp: string,
    public_key_modulus: string
    public_key_exponent: number,
    private_key_modulus: string
    private_key_exponent: number
  })
}

variable "postgres_details" {
  type = object({
    host: string,
    username: string,
    password: string
  })
}

variable "activemq_details" {
  type = object({
    broker_url: string,
    username: string,
    password: string
  })
}

variable "cassandra_details" {
  type = object({
    cluster_name: string,
    username: string,
    password: string,
    contact_points: string,
    keyspace: string
  })
}
